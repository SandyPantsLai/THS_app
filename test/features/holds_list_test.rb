require "test_helper"

feature "HoldsList" do
  setup do
    @admin = create(:admin)
    @user2 = create(:user)
    @user3 = create(:user)
    @hold1 = create(:hold, user: @admin)
    @hold2 = create(:hold, user_id: 2)
    @hold3 = create(:hold, user_id: 2)
    @hold4 = create(:hold, user_id: 3)
    @holds = [@hold1, @hold2, @hold3, @hold4]
  end

  scenario "holds index page displays a list of USERS's holds if the user is NOT an admin" do
    visit holds_path
    fill_in "Email", with: @user2.email
    fill_in "Password", with: "4321"
    click_button "Login"
    page.has_content?(Book.find(@hold2.book_id).title)
    page.has_no_content?(Book.find(@hold1.book_id).title)
    page.has_no_selector?("user")
  end

  scenario "holds index page displays a list of ALL holds if the user is an admin" do
    visit holds_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    visit holds_path
    page.has_selector?("user")
    @holds.each do |hold|
      page.has_content?(Book.find(hold.book_id).title)
    end
  end

  scenario "admin sees list of own holds after they click a link on the holds index page" do
    visit holds_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    visit holds_path
    click_link "View My Holds"
    page.has_no_selector?("user")
  end
end
