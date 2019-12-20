# coding: utf-8
require 'test_helper'

class UserSignupLoginTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:orange_1)
    ActionMailer::Base.deliveries.clear
  end

  test "user signup failure" do
    password="password"
    post signup_path ,params:{ user: {name:"",email:"",
      password:password,
                                      password_confirmation:password}} 
                                      assert_not logged_in_check
                                      assert_template "users/new"
    post signup_path ,params:{ user: {name:"hhoogehoge1",email:"test@gmail.com",
      password:password,
      password_confirmation:"passwordd"}} 
      assert_not logged_in_check
      assert_template "users/new" 
      assert_select "div","ユーザー登録に失敗しました"
    end
    
    test "user signup ,login and logout" do
      get signup_path
      assert_template "users/new"
      password = "password"
      assert_difference "User.count"  do 
        post signup_path, params: { user: {name:"hogehoge",email:"hogehoge@gmail.com",
                                           password:password,
                                           password_confirmation:password}}
      end 
      assert_equal 1 ,ActionMailer::Base.deliveries.size
      user = assigns(:user)
      assert_not user.activated?
      assert_not logged_in_check
        # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
      assert_not logged_in_check
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: 'wrong')
      assert_not logged_in_check
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      assert user.reload.activated?
      follow_redirect!
      assert_template 'users/show'
      assert logged_in_check
    end

    #remember_meテスト

    test "remember_me" do
     get login_path
      #チェックボックスをオン
      login_test(@user,remember_me:"1")
      assert logged_in_check
      user = assigns(:user)
      assert_not_empty cookies['remember_token']
      delete logout_path
      #チェックボックスをオフ
      login_test(@user,remember_me:"0")
      assert logged_in_check
      assert_empty cookies["remember_token"]
    end
    
    test "only login" do 
      get login_path
      login_test(@user)
      assert :success
    end
    
  end
