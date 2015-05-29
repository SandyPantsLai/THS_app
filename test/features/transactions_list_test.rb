require "test_helper"

feature "TransactionsList" do
  setup do
    @admin = create(:admin)
    @user = create(:user)
    @check_out1 = create(:check_out, user: @admin)
    @check_out2 = create(:check_out, user: @user)
    @fine1 = create(:fine, amount: 25, check_out_id: @check_out1, settlement_date: Time.now - 2.days)
    @fine2 = create(:fine, amount: 50, check_out_id: @check_out2)
    @member_fee1 = create(:member_fee, amount: 500, user: @admin, settlement_date: Time.now - 28.days)
    @member_fee2 = create(:member_fee, amount: 1000, user: @user, settlement_date: Time.now - 28.days)
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "4321"
    click_button "Login"
    visit charges_path
  end

  #items include fines (overdue and damage/lost), deposit top ups and member fees
  scenario "As a user, I can see a list of all transaction items with a link to pay what is due" do
    assert page.has_content?(@fine2.amount)
    assert page.has_content?(@member_fee2.amount)
    assert page.has_no_content?(@fine1.amount)
    assert page.has_no_content?(@member_fee2.amount)
    assert page.has_link?("Pay Amount Owing")
  end
end