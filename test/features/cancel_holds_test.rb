require "test_helper"

feature "CancelHolds" do
  setup do
    @user1 = create(:user)
    @user2 = create(:user)
    @hold1 = create(:hold, user: @user1, pickup_expiry: Time.now + 2.days)
    @hold2 = create(:hold, book: @hold1.book, user: @user2)
    visit login_path
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit holds_path
  end

  scenario "When a hold is cancelled, it is removed from the list of holds" do
    page.find('.cancel').click
    assert_equal(Hold.first, @hold2)
  end

  scenario "If a hold with a pickup_expiry is cancelled, the next hold in queue is updated with a pickup_expiry" do
    page.find('.cancel').click
    assert @hold2.pickup_expiry
  end
end