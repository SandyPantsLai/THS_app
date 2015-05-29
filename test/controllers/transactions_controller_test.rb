require "test_helper"

describe TransactionsController do
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

end
