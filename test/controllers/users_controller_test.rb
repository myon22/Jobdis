require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:ishizaki)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "edit user" do
    login_test(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
  end

end
