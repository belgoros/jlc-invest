require 'spec_helper'

feature "Operations page", before_all_records: true do

  given(:admin) { create(:admin) }

  background do
    create(:deposit,
            value_date: Date.today,
            sum: 1000,
            rate: 2.5,
            withholding: 12,
            close_date: Date.today + 3.months)

    sign_in_with_browser(admin)
    visit operations_path
  end

  scenario "Has correct titles" do
    expect(page).to have_title(I18n.t(:list_all, model: Operation.model_name.human.pluralize))
    expect(page).to have_selector('h2', text: I18n.t(:list_all, model: Operation.model_name.human.pluralize))
  end
end
