class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email:params[:email])
    if user && !user.activated? && user.authenticated?(:activate,params[:id])
      user.update_attribute(:activate_at,Time.zone.now)
      user.update_attribute(:activated,true)
      flash[:success] = "アカウントの有効化に成功しました"
      log_in user
      redirect_to user
    else
      flash[:danger] = "アカウントの有効化に失敗しました"
      redirect_to root_url
    end
  end
end
