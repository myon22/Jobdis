# coding: utf-8
require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:ishizaki)
    ActionMailer::Base.deliveries.clear
  end

  test "password_reset" do
    get new_password_reset_path
    assert_template "password_resets/new"
    #emailが無効な場合
    post password_resets_path ,params:{reset_param:{email:""}}
    assert_not flash.empty?
    assert_template "password_resets/new"
    #emailが有効な場合
    post password_resets_path ,params:{reset_param:{email:@user.email}}
    assert_equal 1,ActionMailer::Base.deliveries.size
    assert_not_equal @user.reset_digest ,@user.reload.reset_digest
    user = assigns(:user)
    assert user.reset_token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template "password_resets/edit"
  end
end
