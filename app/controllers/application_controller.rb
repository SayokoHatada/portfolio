class ApplicationController < ActionController::Base
  before_action :require_login

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  def not_authenticated
    redirect_to login_path
  end

  def require_login
    unless current_user
      redirect_to login_path
    end
  end

end
