require "test_helper"

feature "HoldsList" do
  scenario "holds index page displays a list of USERS's holds if the user is NOT an admin" do
    @user = create(:user)
    @hold1 = create(:hold, user: @user)
    @hold2 = create(:hold, user_id: 2)

    visit holds_path
    page.has_content?(Book.find(@hold2.book_id).title)
    page.has_no_content?(Book.find(@hold1.book_id).title)
  end

  scenario "holds index page displays a list of ALL holds if the user is an admin" do
    @admin = create(:admin)
    @hold1 = create(:hold, user: @admin)
    @hold2 = create(:hold, user_id: 2)
    @hold3 = create(:hold, user_id: 2)
    @hold4 = create(:hold, user_id: 3)
    @holds = [@hold1, @hold2, @hold3, @hold4]

    visit holds_path
    page.has_content?("user")
    @holds.each do |hold|
      page.has_content?(Book.find(hold.book_id).title)
    end
  end

  scenario "admin sees list of own holds after they click a link on the holds index page" do
    @admin = create(:admin)
    @user2 = create(:user)
    @user3 = create(:user)
    @hold1 = create(:hold, user: @admin)
    @hold2 = create(:hold, user_id: 2)
    @hold3 = create(:hold, user_id: 2)
    @hold4 = create(:hold, user_id: 3)
    @holds = [@hold1, @hold2, @hold3, @hold4]
    visit login_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    visit holds_path
    click_link "View My Holds"
    page.has_no_selector?("user")
  end
end
