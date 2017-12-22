class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
  end

  def logout
    sign_out
    redirect_to root_path, notice: t('devise.sessions.signed_out')
  end
end
