class KitchenController < ApplicationController
  def dashboard
    @pending_orders = Order.pending.includes(:table, :order_items, :menu_items).order(:created_at)
    @cooking_orders = Order.cooking.includes(:table, :order_items, :menu_items).order(:created_at)
    @ready_orders = Order.ready.includes(:table, :order_items, :menu_items).order(:created_at)
    @completed_today = Order.completed.where('DATE(order_date) = ?', Date.current).count
  end
  
  def start_cooking
    @order = Order.find(params[:id])
    
    if @order.update(status: 'cooking')
      render json: { 
        success: true, 
        message: 'Order status updated to cooking',
        status: 'cooking'
      }
    else
      render json: { success: false, message: 'Failed to update order status' }
    end
  end
  
  def mark_ready
    @order = Order.find(params[:id])
    
    if @order.update(status: 'ready')
      render json: { 
        success: true, 
        message: 'Order is ready for pickup',
        status: 'ready'
      }
    else
      render json: { success: false, message: 'Failed to update order status' }
    end
  end
  
  def order_details
    @order = Order.find(params[:id])
    @order_items = @order.order_items.includes(:menu_item)
    
    render partial: 'order_details', locals: { order: @order, order_items: @order_items }
  end
end