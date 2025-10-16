require "test_helper"

class Admin::JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_jobs_index_url
    assert_response :success
  end
end
