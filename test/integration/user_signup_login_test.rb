require 'test_helper'

class UserSignupLoginTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:orange_1)
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
      follow_redirect!
      assert_template "users/show"
      assert logged_in_check
      assert_select "a[href=?]" , login_path,count:0
      assert_select "a[href=?]" , signup_path,count:0
      assert_select "a[href=?]" , logout_path,count:1
      assert_select "div","ユーザー登録に成功しました"
      #以下ログアウトテスト
      delete logout_path
      assert session[:user_id].nil?
      assert_not logged_in_check
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