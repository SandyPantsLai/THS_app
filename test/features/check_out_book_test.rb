require "test_helper"

feature "CheckOutBook" do
  setup do
    @admin = create(:admin)
    @user1 = create(:user)
    @user2 = create(:user)
    @book = create(:book)
    @copy1 = create(:book_copy, book: @book)
    @copy2 = create(:book_copy, book: @book)
    @check_out = create(:check_out)
    visit login_path
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "1234"
    click_button "Login"
    click_link "Admin Panel"
    click_link "Checkouts"
  end

  scenario "An admin can check out a book" do
    fill_in "User Id", with: @user1.id
    fill_in "Book Copy Id", with: @copy1.id
    click_button "Check Out Book"
    assert_equal(CheckOut.last.book_copy, @copy1)
  end
end