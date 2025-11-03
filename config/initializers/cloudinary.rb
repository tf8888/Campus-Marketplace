# Configure Cloudinary from ENV if available. In production, set CLOUDINARY_URL.
# Example: CLOUDINARY_URL=cloudinary://API_KEY:API_SECRET@CLOUD_NAME

# Always require cloudinary so it's available in production
require "cloudinary"

if ENV["CLOUDINARY_URL"].present?
  Cloudinary.config_from_url(ENV["CLOUDINARY_URL"]) # Uses the full URL config
  # Ensure secure URLs by default
  Cloudinary.config.secure = true
end
