class ApplicationController < ActionController::Base
  before_action :require_login, unless: :public_page?
  add_flash_types :success, :danger

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private

  def not_authenticated
    redirect_to login_path
  end

  def require_login
    unless current_user
      redirect_to login_path, notice: "ログインが必要です"
    end
  end

  def public_page?
    [ "/pages/privacy_policy", "/pages/terms_of_use" ].include?(request.path)
  end
end
