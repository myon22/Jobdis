require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:orange_1)
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

end
