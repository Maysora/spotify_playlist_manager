class HomeController < ApplicationController
  def show
  end

  def logout
    sign_out
    redirect_to root_path, notice: t('devise.sessions.signed_out')
  end
end
