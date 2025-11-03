require "securerandom"
require "fileutils"

# Service object to handle image uploads for Items.
# - In production (when CLOUDINARY_URL present), uploads to Cloudinary and returns the secure URL.
# - In development/test, stores the file under public/uploads and returns a relative URL like /uploads/...
# The controller should pass an ActionDispatch::Http::UploadedFile (params[:item][:image_file]).

class ImageUploader
  ALLOWED_CONTENT_TYPES = [ "image/jpeg", "image/png", "image/gif", "image/webp" ].freeze
  MAX_BYTES = 10 * 1024 * 1024 # 10MB safety cap

  class UploadError < StandardError; end

  def self.upload(uploaded_file, folder: "items")
    raise UploadError, "No file provided" unless uploaded_file

    content_type = uploaded_file.content_type.to_s
    raise UploadError, "Unsupported file type" unless ALLOWED_CONTENT_TYPES.include?(content_type)

    size = uploaded_file.size.to_i
    raise UploadError, "File too large" if size > MAX_BYTES

    if cloudinary_enabled?
      upload_to_cloudinary(uploaded_file, folder: folder)
    else
      store_locally(uploaded_file, folder: folder)
    end
  end

  def self.cloudinary_enabled?
    ENV["CLOUDINARY_URL"].present? && Rails.env.production?
  end

  def self.upload_to_cloudinary(uploaded_file, folder: "items")
    # Cloudinary is already required in initializer
    result = Cloudinary::Uploader.upload(
      uploaded_file.tempfile.path,
      folder: folder,
      overwrite: true,
      resource_type: :image,
      use_filename: true,
      unique_filename: true
    )

    result["secure_url"] || result["url"]
  rescue => e
    raise UploadError, "Cloudinary upload failed: #{e.message}"
  end

  def self.store_locally(uploaded_file, folder: "items")
    # Ensure uploads directory exists
    uploads_dir = Rails.root.join("public", "uploads", folder)
    FileUtils.mkdir_p(uploads_dir)

    # Generate a unique filename preserving extension
    original = uploaded_file.original_filename.to_s
    ext = File.extname(original)
    basename = File.basename(original, ext).parameterize.presence || "image"
    filename = "#{basename}-#{SecureRandom.uuid}#{ext}"

    destination = uploads_dir.join(filename)

    # Move/copy file to destination
    File.open(destination, "wb") do |file|
      file.write(uploaded_file.read)
    end

    # Return a public path
    File.join("/uploads", folder, filename)
  rescue => e
    raise UploadError, "Local storage failed: #{e.message}"
  end
end
