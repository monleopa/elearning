class UsersController < ApplicationController
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
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id] 
    return if @user 
    flash[:danger] = t ".not_found"
    redirect_to users_path
  end

  private
  
  def user_params
    params.require(:user).permit :name, :email, :password
  end
end
