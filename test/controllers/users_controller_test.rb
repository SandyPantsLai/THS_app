require 'test_helper'

class UsersControllerTest < ActionController::TestCase

def setup
    user = users(:one)
    login_user(user)
end
  # test "the truth" do
  #   assert true
  # end
end
