require "test_helper"

feature "HoldsList" do
  setup do
    @admin = create(:admin)
    @user2 = create(:user)
    @hold1 = create(:hold, user: @admin)
    @hold2 = create(:hold, user_id: 2)
    visit login_path
  end

  scenario "holds index page displays a list of USERS's holds if the user is NOT an admin" do
    fill_in "Email", with: @user2.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit holds_path
    assert page.has_content?(Book.find(@hold2.book_id).title)
    assert page.has_no_content?(Book.find(@hold1.book_id).title)
  end

  scenario "holds index page displays a list of ALL holds if the user is an admin" do
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    visit holds_path
    Hold.all.each do |hold|
      assert page.has_text?(Book.find(hold.book_id).title)
    end
  end

  scenario "admin sees list of own holds after they click a link on the holds index page" do
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    visit holds_path
    click_link "View My Holds"
    assert page.has_no_content?(Book.find(@hold2.book_id).title)
  end
end
