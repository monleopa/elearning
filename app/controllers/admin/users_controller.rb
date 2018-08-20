module Admin
  class UsersController < AdminController
    before_action :logged_in_user, :admin_user,
      only: %i(load_user index)
    before_action :load_user, except: %i(index)
    before_action :correct_user, only: %i(edit update)

    def index
      @users = User.selected.ordered
        .page(params[:page]).per Settings.users.records
    end

    def edit; end

    def update
      if @user.update_attributes user_params
        flash[:success] = t ".profile_updated"
        redirect_to admin_user_url(@user)
      else
        render admin: :edit
      end
    end

    def show; end

    def destroy
      if @user.destroy
        flash[:success] = t ".success_delete", user_name: @user.name
        redirect_to admin_root_url
      else
        flash[:danger] = t ".error_delete"
      end
    end

    private

    def load_user
      return if @user = User.find_by(id: params[:id])
      flash[:danger] = t ".not_found"
      redirect_to admin_root_url
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
      redirect_to admin_root_url
    end

    def admin_user
      return if current_user.admin?
      redirect_to root_url
    end
  end
end
