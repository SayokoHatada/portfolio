class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    Rails.logger.debug "OAuth request initiated for provider: #{auth_params[:provider]}"
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    Rails.logger.debug "Provider: #{provider}"
    Rails.logger.debug "Auth Params: #{auth_params.inspect}"

    if auth_params[:error].present?
      Rails.logger.error "OAuth Error: #{auth_params[:error_description]}"
      redirect_to login_path, alert: "ログインに失敗しました: #{auth_params[:error_description]}"
      return
    end

    if (@user = login_from(provider))
      Rails.logger.debug "User logged in: #{@user.inspect}"
      redirect_to diaries_path, notice: "#{provider.titleize}でログインしました"
    else
      Rails.logger.debug "No user found, creating user."
      begin
        @user = create_from(provider)
        Rails.logger.debug "User created: #{@user.inspect}"
        reset_session
        auto_login(@user)
        redirect_to diaries_path, notice: "#{provider.titleize}でログインしました"
      rescue StandardError => e
        Rails.logger.error "Error creating user: #{e.message}"
        redirect_to login_path, alert: "#{provider.titleize}でのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :error, :state, :error_description)
  end
end
