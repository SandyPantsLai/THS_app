require 'test_helper'

class HoldsControllerTest < ActionController::TestCase

  def setup
    user = users(:one)
    login_user(user)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get delete" do
    get :delete
    assert_response :success
  end

end
