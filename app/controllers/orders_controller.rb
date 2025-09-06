class OrdersController < ApplicationController
  before_action :load_menu_items, only: [:new, :create]
  
  def new
    @order = Order.new
    @order.order_items.build
  end
  
  def create
    @order = Order.new(order_params)
    @order.status = 'pending'
    @order.total_amount = 0 # Will be calculated by order items
    
    if @order.save
      # Calculate total amount after saving order items
      @order.calculate_total
      redirect_to order_confirmation_path(@order), notice: 'Order placed successfully!'
    else
      render :new
    end
  end
  
  def confirmation
    @order = Order.find(params[:id])
  end
  
  private
  
  def load_menu_items
    @menu_items = MenuItem.for_date(Date.current).active.order(:name)
  end
  
  def order_params
    params.require(:order).permit(:customer_name, :table_id, order_items_attributes: [:menu_item_id, :quantity, :unit_price])
  end
end