require 'test_helper'

class StartPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title" ,"Job Dis"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title" ,"about | Job Dis"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title" ,"contact | Job Dis"
  end

end
