class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: %i(edit update)

  def new; end

  def create
    @user= User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".psswd_reset_email"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found"
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".nil_psswd")
      render :edit
    elsif @user.update_attributes user_params
      flash[:success] = t ".reset_success"
      redirect_to login_path
    else
      render :edit
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    return if @user = User.find_by email: params[:email]
    flash[:danger] = t ".email_not_found"
    render :new
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return if @user.password_reset_available?
    flash[:danger] = t ".expired_link"
    redirect_to new_password_reset_url
  end
end
