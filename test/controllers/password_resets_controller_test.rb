require "test_helper"

describe PasswordResetsController do
  it "should get create" do
    get :create
    assert_response :success
  end

  it "should get edit" do
    get :edit
    assert_response :success
  end

  it "should get update" do
    get :update
    assert_response :success
  end

end
