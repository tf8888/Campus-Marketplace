class ItemsController < ApplicationController
  before_action :set_item, only: [ :show, :edit, :update, :destroy, :mark_unavailable ]

  before_action :authorize_user!, only: [ :edit, :update, :destroy, :mark_unavailable ]

  def index
    sort_by = params[:sort_by] || "title"
    order = params[:order] || "asc"

    @items = Item.where(available: true)
                 .order("#{sort_by} #{order}")

    if params[:query].present?
      @items = @items.where("LOWER(title) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)",
                          "%#{params[:query]}%",
                          "%#{params[:query]}%")
    end
    if params[:category_id].present?
      @items = @items.where(category_id: params[:category_id])
    end

    @search_query = params[:query]
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

    if @item.save
      redirect_to @item, notice: "Item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
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
    params.require(:item).permit(:title, :description, :condition, :available, :for_lend, :for_sale, :location, :image_url, :category_id)
  end

  def authorize_user!
    redirect_to items_path, alert: "You are not authorized to modify this item." unless @item.user == current_user
  end
end
