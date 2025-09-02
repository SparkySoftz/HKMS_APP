class Admin::UsersController < ApplicationController
  before_action :check_admin_session
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.all.order(:username)
    @total_users = @users.count
    @active_users = @users.active.count
    @roles_count = @users.group(:role).count
  end
  
  def show
    # Show user details
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "User '#{@user.username}' created successfully!"
      redirect_to admin_users_path
    else
      flash.now[:error] = "Failed to create user. Please check the form."
      render :new
    end
  end
  
  def edit
    # Edit user form
  end
  
  def update
    # Remove password fields if they're empty (for updates without password change)
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    if @user.update(user_params)
      flash[:success] = "User '#{@user.username}' updated successfully!"
      redirect_to admin_users_path
    else
      flash.now[:error] = "Failed to update user. Please check the form."
      render :edit
    end
  end
  
  def destroy
    username = @user.username
    
    if @user.destroy
      flash[:success] = "User '#{username}' deleted successfully!"
    else
      flash[:error] = "Failed to delete user '#{username}'."
    end
    
    redirect_to admin_users_path
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "User not found."
    redirect_to admin_users_path
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, 
                                 :first_name, :last_name, :phone, :role, :status)
  end
  
  def check_admin_session
    unless session[:admin_logged_in] == true
      flash[:error] = "Please login as admin to access this area."
      redirect_to admin_login_path
    end
  end
end
