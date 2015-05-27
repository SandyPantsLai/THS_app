require "test_helper"

feature "CheckOutBook" do
  setup do
    @book = create(:book)
    @copy = create(:book_copy, book: @book)
    visit login_path
  end

  scenario "An admin can check out a book" do
    @admin = create(:admin)
    @user = create(:user)

    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    click_link "Checkouts"
    fill_in "User Id", with: @user.id
    fill_in "Book Copy Id", with: @copy.id
    click_button "Check Out Book"
    assert_equal(CheckOut.last.book_copy, @copy)
  end

  scenario "A normal user cannot check out a book" do
    @user = create(:user)
    fill_in "Email", with: @user.email
    fill_in "Password", with: "4321"
    visit new_check_out_path
    page.has_content?("error")
  end
end