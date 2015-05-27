require "test_helper"

feature "CancelHolds" do
  setup do
    @user1 = create(:user)
    @user2 = create(:user)
    @hold1 = create(:hold, user: @user1, pickup_expiry: Time.now + 2.days)
    @hold2 = create(:hold, book: @hold1.book, user: @user2)
    visit login_path
  end

  scenario "A user can cancel their own hold" do
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit holds_path
    page.find('.cancel').click
    assert_equal(Hold.first, @hold2)
  end
end