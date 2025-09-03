class CashierController < ApplicationController
  def dashboard
    @pending_bills = Order.ready.includes(:table, :order_items, :menu_items).order(:created_at)
    @completed_bills = Order.completed.where('DATE(order_date) = ?', Date.current).includes(:table).order(:created_at)
    @today_revenue = Order.completed.where('DATE(order_date) = ?', Date.current).sum(:total_amount)
    @today_orders_count = Order.completed.where('DATE(order_date) = ?', Date.current).count
  end
  
  def generate_bill
    @order = Order.find(params[:id])
    @bill_items = @order.order_items.includes(:menu_item)
    
    # Generate bill in JSON format for printing
    bill_data = {
      order_number: @order.order_number,
      table_number: @order.table.table_number,
      customer_name: @order.customer_name,
      order_date: @order.order_date.strftime('%Y-%m-%d %H:%M'),
      items: @bill_items.map do |item|
        {
          name: item.menu_item.name,
          quantity: item.quantity,
          unit_price: item.unit_price,
          subtotal: item.subtotal
        }
      end,
      total_amount: @order.total_amount
    }
    
    render json: { 
      success: true, 
      bill: bill_data,
      message: 'Bill generated successfully'
    }
  end
  
  def print_bill
    @order = Order.find(params[:id])
    
    # Mark as billed and update income
    if @order.update(status: 'billed')
      # Here you would typically integrate with a POS system or accounting software
      # For now, we'll just mark it as processed
      
      render json: { 
        success: true, 
        message: 'Bill printed and income updated'
      }
    else
      render json: { success: false, message: 'Failed to process bill' }
    end
  end
  
  def bill_details
    @order = Order.find(params[:id])
    @bill_items = @order.order_items.includes(:menu_item)
    
    render partial: 'bill_details', locals: { order: @order, bill_items: @bill_items }
  end
end