class Admin::AnalyticsController < ApplicationController
  before_action :check_admin_session
  
  def index
    # Overall statistics
    @total_revenue = Order.completed.sum(:total_amount)
    @total_orders = Order.count
    @total_users = User.count
    @total_menu_items = MenuItem.count
    
    # Recent statistics (last 7 days)
    @recent_revenue = Order.completed.where('created_at >= ?', 7.days.ago).sum(:total_amount)
    @recent_orders = Order.where('created_at >= ?', 7.days.ago).count
    @recent_users = User.where('created_at >= ?', 7.days.ago).count
    
    # Order statistics by status
    @orders_by_status = Order.group(:status).count
    
    # Orders by day for the last 7 days
    @orders_by_day = Order.where('created_at >= ?', 7.days.ago)
                         .group("DATE(created_at)")
                         .order("DATE(created_at)")
                         .count
    
    # Revenue by day for the last 7 days
    @revenue_by_day = Order.completed.where('created_at >= ?', 7.days.ago)
                                    .group("DATE(created_at)")
                                    .order("DATE(created_at)")
                                    .sum(:total_amount)
    
    # Top menu items by order count (fixed association)
    @top_menu_items = MenuItem.joins(order_items: :order)
                             .where(orders: { status: 'completed' })
                             .group('menu_items.id, menu_items.name')
                             .order('COUNT(order_items.id) DESC')
                             .limit(5)
                             .count('order_items.id')
    
    # User registration by day (last 7 days)
    @user_registrations_by_day = User.where('created_at >= ?', 7.days.ago)
                                    .group("DATE(created_at)")
                                    .order("DATE(created_at)")
                                    .count
    
    # Average order value
    @average_order_value = @total_orders > 0 ? (@total_revenue / @total_orders).round(2) : 0
    
    # Feedback statistics
    @feedback_stats = Feedback.group(:rating).count
    @average_rating = Feedback.count > 0 ? (Feedback.sum(:rating).to_f / Feedback.count).round(2) : 0
  end
  
  private
  
  def check_admin_session
    unless session[:admin_logged_in] == true
      flash[:error] = "Please login as admin to access this area."
      redirect_to admin_login_path
    end
  end
end