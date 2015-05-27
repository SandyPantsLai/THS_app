require "test_helper"

feature "CheckOutBook" do
  setup do
    @book = create(:book)
    @copy = create(:book_copy, book: @book)
    @user = create(:user)
    visit login_path
  end

  scenario "An admin can check out a book" do
    @admin = create(:admin)
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
    fill_in "Email", with: @user.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit new_check_out_path
    fill_in "User Id", with: @user.id
    fill_in "Book Copy Id", with: @copy.id
    click_button "Check Out Book"
    assert page.has_text?("Please see an admin to check out a book.")
  end

  scenario "A book holds cannot be checked out unless current patron has a hold ready for pickup" do
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