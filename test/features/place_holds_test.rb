require "test_helper"

feature "PlaceHolds" do
  setup do
    @user1 = create(:user)
    @user2 = create(:user)
    @hold1 = create(:hold, user: @user1)
    @hold2 = create(:hold, user: @user2, pickup_expiry: Time.now + 2.days)
    @copy1 = create(:book_copy, book: @hold2.book)
    @copy2 = create(:book_copy, book: @hold2.book)
    @book = create(:book)
    visit login_path
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "4321"
    click_button "Login"
  end

  scenario "a user CANNOT place a hold on a book if they already have an active hold for it" do
    visit book_path(@hold1.book)
    assert page.has_no_link?("Place a hold")
  end

  scenario "a user can place a hold on a book if they do not already have an active hold for it" do
    visit book_path(@book)
    click_link "Place a hold"
    click_button "Confirm Hold"
    assert_not_equal(Hold.last, @hold2)
  end

  scenario "if there is a copy of a book available, the newly placed hold is available for immediate pick up." do
    visit book_path(@hold2.book)
    click_link "Place a hold"
    click_button "Confirm Hold"
    assert page.has_content?("You have until #{Hold.last.pickup_expiry.strftime("%A, %b %e, %Y")} to pick up your book.")
  end

end