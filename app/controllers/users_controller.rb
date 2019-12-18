class UsersController < ApplicationController
  before_action :user_logged? ,only:[:index,:show,:delete,:edit]
  before_action :correct_user? ,only:[:edit]
  before_action :admin_user? ,only:[:delete]

  def index
    @users = User.paginate(page:params[:page])
  end

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

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(:name,params[:name])
      flash[:success] = "編集に成功しました"
      redirect_hisotry(@user)
    else
      flash[:danger] = "編集に失敗しました"
      redirect_to edit_user_path(@user)
    end
  end

  def delete
    User.find(params[:id]).delete
  end

  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    def user_logged?
      unless logged_in?
        location_url
        redirect_to login_path
      end
    end 
    
    def correct_user?
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "あなたのプロフィールではありません"
        redirect_to root_path
       end 
    end

    def admin_user?
      unless User.find(params[:id]).admin?
        flash[:danger] = "管理者ユーザーではありません"
        redirect_to root_path
      end
    end

end
