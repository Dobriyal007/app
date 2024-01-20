require "test_helper"

class FasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fas_index_url
    assert_response :success
  end

  test "should get new" do
    get fas_new_url
    assert_response :success
  end
end
