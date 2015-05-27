require "test_helper"

feature "CheckInBook" do
  setup do
    @user = create(:user)
    @check_out = create(:check_out, user: @user)
    visit login_path
  end

  scenario "An admin can check in a book" do
    @admin = create(:admin)
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    visit check_out_path(@check_out)

    click_link "Return Book"
    refute @check_out.return_date == nil
  end

  scenario "A normal user cannot check in a book" do
    fill_in "Email", with: @user.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit new_check_out_path
    fill_in "User Id", with: @user.id
    fill_in "Book Copy Id", with: @copy.id
    click_link "Return Books"
    refute  ("Please see an admin to check out a book.")
  end

  scenario "If a book is checked in with holds with a null pickup_expiry, the next hold is updated with a pickup_expiry" do
    @user2 = create(:user)
    @hold = create(:hold, book: @book, user: @user2)
    @admin = create(:admin)
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    visit new_check_out_path
    fill_in "User Id", with: @user.id
    fill_in "Book Copy Id", with: @copy.id
    click_button "Check Out Book"
    assert page.has_text?("This book is on hold for another user.")
  end
end