class PasswordResetsController < ApplicationController
  before_action :get_user ,only:[:edit,:update]
  before_action :valid_user ,only:[:edit,:update]
  before_action :check_time,only:[:edit,:update]

  def new
  end

  def create
    @user = User.find_by(email:params[:reset_param][:email].downcase) 
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = "メールを送りました、ご確認ください。"
      redirect_to root_path
    else
      flash.now[:danger] = "メールアドレスが正しくありません"
      render "new"
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password ,"パスワードが入力されていません。")
      render 'edit'
    elsif @user.update_attributes(pass_params)
      log_in @user
      flash[:success] = "パスワードの再設定に成功しました。"
      redirect_to @user
    else
      flash[:danger] = "パスワードが一致しません"
      render 'edit'
    end
  end

  private
  def pass_params
    params.require(:user).permit(:password,:password_confirmation)
  end 

  def get_user
    @user = User.find_by(email:params[:email])
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset,params[:id]))
      flash[:danger] = "有効なユーザーではありません"
      redirect_to roots_path
    end
  end

  def check_time
    if @user.password_reset_expire?
      flash[:danger] = "メールの有効期限が切れています"
      redirect_to root_path
    end
  end
end
