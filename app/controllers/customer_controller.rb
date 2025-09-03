class CustomerController < ApplicationController
  before_action :ensure_customer_session, except: [:login, :table_selection, :qr_scan]
  
  def login
    # Customer login page
  end
  
  def table_selection
    @available_tables = Table.available.order(:table_number)
  end
  
  def select_table
    @table = Table.find(params[:table_id])
    if @table.available?
      session[:table_id] = @table.id
      session[:customer_name] = params[:customer_name]
      redirect_to customer_menu_path
    else
      redirect_to customer_table_selection_path, alert: 'Table is not available'
    end
  end
  
  def qr_scan
    @qr_code = params[:qr_code]
    @table = Table.find_by(qr_code: @qr_code)
    
    if @table && @table.available?
      session[:table_id] = @table.id
      redirect_to customer_login_path
    else
      redirect_to customer_table_selection_path, alert: 'Invalid QR code or table not available'
    end
  end
  
  def menu
    @table = current_table
    @menu_items = MenuItem.for_date(Date.current).active.order(:name)
    @current_order = find_or_create_current_order
  end
  
  def add_to_order
    @table = current_table
    @menu_item = MenuItem.find(params[:menu_item_id])
    @current_order = find_or_create_current_order
    
    order_item = @current_order.order_items.find_or_initialize_by(menu_item: @menu_item)
    order_item.quantity = (order_item.quantity || 0) + params[:quantity].to_i
    order_item.unit_price = @menu_item.price
    
    if order_item.save
      render json: { 
        success: true, 
        message: 'Item added to order',
        order_total: @current_order.reload.total_amount,
        item_count: @current_order.order_items.count
      }
    else
      render json: { success: false, message: 'Failed to add item' }
    end
  end
  
  def view_order
    @table = current_table
    @current_order = find_or_create_current_order
    @order_items = @current_order.order_items.includes(:menu_item)
  end
  
  def place_order
    @current_order = find_or_create_current_order
    
    if @current_order.order_items.any?
      @current_order.update(status: 'pending')
      redirect_to customer_order_status_path, notice: 'Order placed successfully!'
    else
      redirect_to customer_menu_path, alert: 'Please add items to your order first'
    end
  end
  
  def order_status
    @table = current_table
    @current_order = current_order
    @order_items = @current_order.order_items.includes(:menu_item) if @current_order
  end
  
  def give_feedback
    @order = Order.find(params[:order_id])
    @feedback = @order.build_feedback
  end
  
  def submit_feedback
    @order = Order.find(params[:order_id])
    @feedback = @order.build_feedback(feedback_params)
    
    if @feedback.save
      @order.update(status: 'completed')
      session.delete(:table_id)
      session.delete(:customer_name)
      redirect_to customer_thank_you_path, notice: 'Thank you for your feedback!'
    else
      render :give_feedback
    end
  end
  
  def thank_you
    # Thank you page after completing order
  end
  
  private
  
  def ensure_customer_session
    unless session[:table_id] && session[:customer_name]
      redirect_to customer_login_path
    end
  end
  
  def current_table
    @current_table ||= Table.find(session[:table_id]) if session[:table_id]
  end
  
  def current_order
    @current_order ||= current_table.orders.active.first if current_table
  end
  
  def find_or_create_current_order
    return current_order if current_order
    
    current_table.orders.create!(
      customer_name: session[:customer_name],
      status: 'draft',
      total_amount: 0
    )
  end
  
  def feedback_params
    params.require(:feedback).permit(:rating, :comment)
  end
end