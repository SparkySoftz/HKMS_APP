class ManagerController < ApplicationController
  def dashboard
    @expiring_items = InventoryItem.expiring_soon.includes(:supplier)
    @expired_items = InventoryItem.expired.includes(:supplier)
    @low_stock_items = InventoryItem.where('quantity <= 5').includes(:supplier)
    @available_items = InventoryItem.available.includes(:supplier)
    @today_menu = MenuItem.current_menu
    @recent_transactions = StorekeeperTransaction.includes(:supplier).order(created_at: :desc).limit(5)
    
    # Calculate alerts count
    @alerts_count = @expiring_items.count + @expired_items.count + @low_stock_items.count
  end
  
  def inventory
    @inventory_items = InventoryItem.includes(:supplier).order(:expiry_date)
  end
  
  def menu_management
    @menu_items = MenuItem.order(:menu_date, :name)
    @available_ingredients = InventoryItem.available.distinct.pluck(:name).sort
  end
end