require 'test_helper'

class HoldsControllerTest < ActionController::TestCase
<<<<<<< HEAD
  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should get show" do
  #   get :show
  #   assert_response :success
  # end

  # test "should get update" do
  #   get :update
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit
  #   assert_response :success
  # end

  # test "should get delete" do
  #   get :delete
  #   assert_response :success
  # end

=======

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
>>>>>>> 0c322ce466d0c6e8b3915b377215d298012d44b0

end
