require "test_helper"

feature "PlaceHolds" do
  setup do
    @admin = create(:admin)
    @user2 = create(:user)
    @hold1 = create(:hold, user: @admin)
    @hold2 = create(:hold, user: @user2)
    @book = create(:book)
  end

  scenario "a user can place a hold on a book if they do not already have an active hold for it" do
    visit login_path
    page.has_content?("user")
    fill_in "Email", with: @user2.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit book_path(@book)
    click_link "Place a hold"
    page.has_no_content?("We were unable to confirm your hold due to these errors")
  end
end