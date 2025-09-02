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
    # Empty admin dashboard - user will add content later
    @admin_username = session[:admin_username]
    # Convert login_time string back to Time object if it exists
    begin
      @login_time = session[:login_time] ? Time.parse(session[:login_time]) : nil
    rescue ArgumentError, TypeError
      # If parsing fails, set to current time as fallback
      @login_time = Time.current
    end
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
