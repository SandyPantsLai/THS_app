require "test_helper"

feature "TransactionsList" do
  setup do
    @admin = create(:admin)
    @user = create(:user)
    @member_fee1 = create(:member_fee, amount: 10000, user: @admin, settlement_date: Time.now - 14.days)
    @member_fee2 = create(:member_fee, amount: 1000, user: @user, settlement_date: Time.now - 28.days)
    @deposit1 = create(:deposit, amount: 4000, user: @admin, settlement_date: Time.now)
    @deposit2 = create(:deposit, amount: 4000, user: @user, settlement_date: Time.now)
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit transactions_path
    binding.pry
  end

  #items include fines (overdue and damage/lost), deposit top ups and member fees
  scenario "As a user, I can see a list of all transaction items with a link to pay what is due" do
    assert page.has_content?(@member_fee2.amount)
    assert page.has_content?(@deposit2.amount)
    assert page.has_no_content?(@member_fee1.amount)
    assert page.has_no_content?(@deposit1.amount)
    assert page.has_link?(new_charge_path)
  end
end