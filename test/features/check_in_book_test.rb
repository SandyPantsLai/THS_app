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
    refute CheckOut.find(1).return_date == nil
  end

  scenario "A normal user cannot check in a book" do
    fill_in "Email", with: @user.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit check_out_path(@check_out)
    assert page.has_no_link? "Return Book"
  end

  scenario "If a book is checked in with holds with a null pickup_expiry, the next hold is updated with a pickup_expiry" do
    @admin = create(:admin)
    @hold = create(:hold, book: Book.find(@check_out.book_copy.book_id))
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    visit check_out_path(@check_out)
    click_link "Return Book"
    refute Hold.first.pickup_expiry == nil
  end
end