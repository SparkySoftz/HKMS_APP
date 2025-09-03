class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @menu_items = MenuItem.order(:menu_date, :name)
  end
  
  def show
  end
  
  def new
    @menu_item = MenuItem.new
    @available_ingredients = InventoryItem.available.distinct.pluck(:name).sort
  end
  
  def create
    @menu_item = MenuItem.new(menu_item_params)
    @menu_item.created_by = 'manager' # In a real app, this would be current_user
    
    if @menu_item.save
      redirect_to menu_items_path, notice: 'Menu item successfully created.'
    else
      @available_ingredients = InventoryItem.available.distinct.pluck(:name).sort
      render :new
    end
  end
  
  def edit
    @available_ingredients = InventoryItem.available.distinct.pluck(:name).sort
  end
  
  def update
    if @menu_item.update(menu_item_params)
      redirect_to menu_items_path, notice: 'Menu item successfully updated.'
    else
      @available_ingredients = InventoryItem.available.distinct.pluck(:name).sort
      render :edit
    end
  end
  
  def destroy
    @menu_item.destroy
    redirect_to menu_items_path, notice: 'Menu item successfully deleted.'
  end
  
  private
  
  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end
  
  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :ingredients, :menu_date, :status)
  end
end