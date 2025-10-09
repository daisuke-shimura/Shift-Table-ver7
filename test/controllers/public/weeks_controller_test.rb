require "test_helper"

class Public::WeeksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_weeks_index_url
    assert_response :success
  end
end
