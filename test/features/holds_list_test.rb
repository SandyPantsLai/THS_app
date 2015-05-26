require "test_helper"

feature "HoldsList" do
  scenario "holds index page displays a list of USERS's holds if the user is NOT an admin" do
    @user = create(:user)
    @hold = create(:hold, user: @user)
    visit holds_path
    page.has_content?(Book.find(@hold.book_id).title)
  end
end
