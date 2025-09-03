class Admin::AuthController < ApplicationController
  before_action :check_admin_session, only: [:dashboard]
  
  # Predefined admin credentials (in production, use database/environment variables)
  ADMIN_CREDENTIALS = {
    username: "admin",
    password: "admin123"
  }.freeze
  
  def login
    # Show admin login form
    redirect_to admin_dashboard_path if admin_logged_in?
  end
  
  def create
    username = params[:username]&.strip
    password = params[:password]&.strip
    
    if valid_admin_credentials?(username, password)
      # Set admin session
      session[:admin_logged_in] = true
      session[:admin_username] = username
      session[:login_time] = Time.current.iso8601
      
      flash[:success] = "Welcome to Admin Panel, #{username}!"
      redirect_to admin_dashboard_path
    else
      flash.now[:error] = "Invalid admin credentials. Please try again."
      render :login
    end
  end
  
  def dashboard
    # Admin dashboard with comprehensive system monitoring
    @admin_username = session[:admin_username]
    # Convert login_time string back to Time object if it exists
    begin
      @login_time = session[:login_time] ? Time.parse(session[:login_time]) : nil
    rescue ArgumentError, TypeError
      # If parsing fails, set to current time as fallback
      @login_time = Time.current
    end
    
    # System statistics for admin monitoring
    @total_users = User.count
    @active_users = User.active.count
    @users_by_role = User.group(:role).count
    @recent_users = User.order(created_at: :desc).limit(5)
    
    # Order statistics
    @total_orders = Order.count
    @active_orders = Order.active.count
    @orders_by_status = Order.group(:status).count
    @recent_orders = Order.order(created_at: :desc).limit(5)
    
    # Menu statistics
    @total_menu_items = MenuItem.count
    @active_menu_items = MenuItem.active.count
    
    # Table statistics
    @total_tables = Table.count
    @available_tables = Table.available.count
    @occupied_tables = Table.occupied.count
    
    # Feedback statistics
    @total_feedbacks = Feedback.count
    @feedbacks_by_rating = Feedback.group(:rating).count
    
    # Calculate revenue statistics
    @total_revenue = Order.completed.sum(:total_amount)
    @recent_revenue = Order.completed.where('created_at >= ?', 7.days.ago).sum(:total_amount)
  end
  
  def destroy
    # Logout admin
    session.delete(:admin_logged_in)
    session.delete(:admin_username)
    session.delete(:login_time)
    
    flash[:info] = "Admin logged out successfully."
    redirect_to roles_path
  end
  
  private
  
  def valid_admin_credentials?(username, password)
    username == ADMIN_CREDENTIALS[:username] && 
    password == ADMIN_CREDENTIALS[:password]
  end
  
  def admin_logged_in?
    session[:admin_logged_in] == true
  end
  
  def check_admin_session
    unless admin_logged_in?
      flash[:error] = "Please login as admin to access this area."
      redirect_to admin_login_path
    end
  end
end