class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email:params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
        log_in @user
        redirect_hisotry(@user)
        flash[:success] = "ログインに成功しました"
      else
        message = "アカウントが有効化されていません。"
        message += "メールの有効化リンクを確認してください"
        flash[:danger] = message
        redirect_to root_path
      end 
    else
      render "new"
      flash[:danger] = "ログインに失敗しました"
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
