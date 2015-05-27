require "test_helper"

feature "PlaceHolds" do
  setup do
    @user1 = create(:user)
    @user2 = create(:user)
    @hold1 = create(:hold, user: @user1)
    @hold2 = create(:hold, user: @user2)
    @book = create(:book)
    visit login_path
    page.has_content?("user")
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "4321"
    click_button "Login"
  end

  scenario "a user can place a hold on a book if they do not already have an active hold for it" do
    visit book_path(@book)
    click_link "Place a hold"
    page.has_no_content?("We were unable to confirm your hold due to these errors")
  end

  scenario "a user CANNOT place a hold on a book if they already have an active hold for it" do
    visit book_path(@hold1.book)
    page.has_no_link?("Place a hold")
  end

  scenario "if there is a copy of a book available, the newly placed hold is available for immediate pick up." do
  end

end