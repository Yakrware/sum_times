require 'test_helper'

class Admin::TimesheetsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get generate" do
    get :generate
    assert_response :success
  end

end
