require 'test_helper'

class UserPageTest < ActionDispatch::IntegrationTest
  def setup 
    @user = users(:ishizaki)
  end

  test "before index login" do 
    get users_path
    assert_redirected_to login_path
  end


  test "index including pagination" do
    login_test(@user)
    get users_path
    assert_template 'users/index'
    #assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]' ,user_path(user)
    end
  end
end
