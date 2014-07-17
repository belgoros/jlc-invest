require 'spec_helper'

feature "Account operations page" do

  given(:admin) { create(:admin) }
  given(:client) { create(:client) }
  given(:account) { create(:account, client: client) }

  background do
    sign_in_with_browser(admin)
    create(:deposit, sum: 1000, rate: 2.5, close_date: Date.today + 2.months, withholding: 21, account: account)
    visit account_path(account)
  end

  scenario "has correct links and title" do
    expect(page).to have_selector('h1', text: client.full_name)
    expect(page).to have_selector('h2', text: I18n.t(:list_all, model: Operation.model_name.human.pluralize))
    expect(page).to have_title(full_title(client.full_name))
    expect(page).to have_link(I18n.t('links.new', model: Operation.model_name.human), href: new_account_operation_path(account))
    expect(page).to have_link(I18n.t('links.back_to_list'), href: client_path(client))
    expect(page).to have_selector('th', text: I18n.t(:account_balance))
  end
end
