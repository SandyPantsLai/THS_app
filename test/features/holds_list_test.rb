require "test_helper"

feature "HoldsList" do
  scenario "holds index page displays a list of USERS's holds if the user is NOT an admin" do
    @user = create(:user)
    @hold = create(:hold, user: @user)
    visit holds_path
    page.has_content?(Book.find(@hold.book_id).title)
  end

  scenario "holds index page displays a list of ALL holds if the user is an admin" do
    @user1 = create(:admin)
    @user2 = create(:user)
    @user3 = create(:user)
    @hold1 = create(:hold, user: @user1)
    @hold2 = create(:hold, user: @user2)
    @hold3 = create(:hold, user: @user3)
    @hold4 = create(:hold, user: @user3)
    @holds = [@hold1, @hold2, @hold3, @hold4]

    visit holds_path
    @holds.each do |hold|
      page.has_selector?("user")
      page.has_content?(Book.find(hold.book_id).title)
    end
  end
end
