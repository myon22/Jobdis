class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー登録に成功しました" 
      log_in @user
      redirect_to @user
    else
      flash[:danger] = "ユーザー登録に失敗しました"
      render "new"
    end
  end

  def show 
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
end
