require 'test_helper'

class AdminUserPerminTest < ActionDispatch::IntegrationTest
  def setup 
    @admin_user    = users(:ishizaki)
    @no_admin_user = users(:orange_0)
  end

  test "admin_user destroy" do
    login_test(@admin_user,remember_me:"1",password:"password")
    get users_path
    User.paginate(page:1).each do |user|
      unless @admin_user == user
        assert_select "a[href=?]" ,user_path(user) ,text:"ユーザー削除"
      end
    end
  end 
end
