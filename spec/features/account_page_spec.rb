require 'spec_helper'

feature "Account page" do
  given(:admin) { create(:admin) }
  given(:client) { create(:client) }
  given(:account) { create(:account, client: client) }

  background do
    sign_in_with_browser(admin)
    create(:deposit, sum: 1000, rate: 2.5, close_date: Date.today + 2.months, withholding: 21, account: account)
    visit client_path(client)
  end

  scenario "has correct links and title" do
    expect(page).to have_selector('h2', text: client.full_name)
    expect(page).to have_selector('h2', text: I18n.t(:list_all, model: Account.model_name.human.pluralize))
    expect(page).to have_title(full_title(client.full_name))
    expect(page).to have_button(I18n.t('add_account'))
    expect(page).to have_link(I18n.t('links.back_to_list'), href: clients_path)
    expect(page).to have_selector('th', text: I18n.t(:account_balance))
    expect(page).to have_link(I18n.t('links.printing'), href: report_account_path(account, format: :pdf))

  end

  scenario "has no printing link when no operations present" do
    account.operations.delete_all
    visit client_path(client)
    expect(page).not_to have_link(I18n.t('links.printing'), href: report_account_path(account, format: :pdf))
  end
end
