require "test_helper"

class Admin::AuthControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get admin_auth_login_url
    assert_response :success
  end

  test "should get create" do
    get admin_auth_create_url
    assert_response :success
  end

  test "should get dashboard" do
    get admin_auth_dashboard_url
    assert_response :success
  end
end
