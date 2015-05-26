require "test_helper"

feature "HoldsList" do
  scenario "holds index page displays a list of holds" do
    visit holds_path
    page.must_have_content @holds
  end
end
