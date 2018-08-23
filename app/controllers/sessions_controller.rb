class SessionsController < ApplicationController
  def new
    return redirect_to root_url if logged_in?
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        log_in user
        params[:session][:remember_me] ? remember(user) : forget(user)
        flash.now[:info] = t ".hello_user"
        redirect_back_or user
      else
        flash[:warning] = t ".check_email"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".error_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
