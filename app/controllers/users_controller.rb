class UsersController < ApplicationController
  before_action :logged_in_user, :load_user, only: %i(show edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.selected.ordered
      .page(params[:page]).per Settings.users.records
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".active_message"
      redirect_to root_url
    else
      flash[:danger] = t ".not_success"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def show; end

  private

  def load_user
    return if @user = User.find_by(id: params[:id])
    flash[:danger] = t ".not_found"
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation, :avatar
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".require_login"
    redirect_to login_url
  end

  def correct_user
    return if current_user? User.find_by(id: params[:id])
    flash[:danger] = t ".error_permission"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?
    redirect_to root_url
  end
end
