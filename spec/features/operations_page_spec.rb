require 'spec_helper'

feature "Operations page" do

  let(:admin) { create(:admin) }

  before(:all) do
    31.times do
        create(:deposit,
                value_date: Date.today,
                sum: 1000,
                rate: 2.5,
                withholding: 12,
                close_date: Date.today + 3.months)
    end
  end

  after(:all) { Operation.delete_all }

  background do
    sign_in_with_browser(admin)
    visit operations_path
  end

  scenario "Has correct titles" do
    expect(page).to have_title(I18n.t(:list_all, model: Operation.model_name.human.pluralize))
    expect(page).to have_selector('h2', text: I18n.t(:list_all, model: Operation.model_name.human.pluralize))
  end

  scenario "List all operations with pagination" do
    expect(page).to have_selector('div.pagination')

    Client.accounts_sum.paginate(page: 1).each do |client|
      expect(page).to have_selector('td', text: client.firstname)
      expect(page).to have_selector('td', text: client.lastname)
      expect(page).to have_selector('td', text: number_to_currency(client.accounts_balance))
    end
  end
end
