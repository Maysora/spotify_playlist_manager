class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def spotify
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Spotify") if is_navigational_format?
    else
      redirect_to root_path, alert: @user.errors.full_messages.first
    end
  end

  def failure
    flash[:alert] = request.env['omniauth.error'].description if request.env['omniauth.error'].respond_to?(:description)
    redirect_to root_path
  end
end
