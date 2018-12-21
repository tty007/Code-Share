require 'test_helper'

class CodesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get codes_index_url
    assert_response :success
  end

  test "should get show" do
    get codes_show_url
    assert_response :success
  end

  test "should get new" do
    get codes_new_url
    assert_response :success
  end

  test "should get edit" do
    get codes_edit_url
    assert_response :success
  end

end
