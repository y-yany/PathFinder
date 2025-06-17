# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: 'Google')
      sign_in_and_redirect @user, event: :authentication
    else
      # 認証情報をセッションに保存
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
      redirect_to new_user_registration_url, error: t('devise.omniauth_callbacks.failure', kind: 'Google')
    end
  end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  protected

  def after_sign_in_path_for(_resource)
    courses_path
  end

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
