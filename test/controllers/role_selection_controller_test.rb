require "test_helper"

class RoleSelectionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get role_selection_index_url
    assert_response :success
  end
end
