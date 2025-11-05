class ItemsController < ApplicationController
  before_action :set_item, only: [ :show, :edit, :update, :destroy, :mark_unavailable ]

  before_action :authorize_user!, only: [ :edit, :update, :destroy, :mark_unavailable ]

  def index
    # Whitelist sort options to prevent SQL injection and ensure valid columns
    allowed_sort_columns = %w[title price condition created_at]
    sort_by = allowed_sort_columns.include?(params[:sort_by]) ? params[:sort_by] : "title"
    order = %w[asc desc].include?(params[:order]) ? params[:order] : "asc"

    @items = Item.where(available: true)

    if params[:query].present?
      @items = @items.where(
        "LOWER(title) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)",
        "%#{params[:query]}%",
        "%#{params[:query]}%"
      )
    end

    if params[:category_id].present?
      @items = @items.where(category_id: params[:category_id])
    end

    # Apply sorting last
    @items = @items.order(sort_by => order.to_sym)

    @search_query = params[:query]
  end

  # Show the current user's listings
  def my_listings
    @my_items = current_user ? current_user.items.order(created_at: :desc) : Item.none
  end

  def show
    if !@item.available && @item.user != current_user
      redirect_to items_path, alert: "This item is no longer available."
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user

    # Handle image file upload if provided
    uploaded = params.dig(:item, :image_file)
    if uploaded.present?
      begin
        @item.image_url = ImageUploader.upload(uploaded, folder: "items")
      rescue ImageUploader::UploadError => e
        @item.errors.add(:image_url, e.message)
        return render :new, status: :unprocessable_entity
      end
    end

    if @item.save
      redirect_to @item, notice: "Item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Process new file upload if present
    uploaded = params.dig(:item, :image_file)
    if uploaded.present?
      begin
        # Upload first and ensure the text field doesn't overwrite it
        new_url = ImageUploader.upload(uploaded, folder: "items")
        # Build attributes to update, excluding image_url from user params when file present
        attrs = item_params.dup
        attrs.delete(:image_url)
        success = @item.update(attrs.merge(image_url: new_url))
        return redirect_to(@item, notice: "Item was successfully updated.") if success
        return render :edit, status: :unprocessable_entity
      rescue ImageUploader::UploadError => e
        @item.errors.add(:image_url, e.message)
        return render :edit, status: :unprocessable_entity
      end
    end

    if @item.update(item_params)
      redirect_to @item, notice: "Item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: "Item was successfully deleted."
  end

  def mark_unavailable
    @item.update(available: false)
    redirect_to @item, notice: "Item marked as unavailable."
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    # image_file is handled separately and not persisted directly
    params.require(:item).permit(:title, :description, :condition, :available, :for_lend, :for_sale, :location, :image_url, :category_id, :price)
  end

  def authorize_user!
    redirect_to items_path, alert: "You are not authorized to modify this item." unless @item.user == current_user
  end
end
