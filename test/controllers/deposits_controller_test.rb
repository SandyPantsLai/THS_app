require "test_helper"

describe DepositsController do
  it "should get index" do
    get :index
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

  it "should get destroy" do
    get :destroy
    assert_response :success
  end

  it "should get initial_deposit" do
    get :initial_deposit
    assert_response :success
  end

end
