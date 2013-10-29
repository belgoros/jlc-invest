require 'spec_helper'

describe "Operations page" do
  subject { page }

  let(:admin) { create(:admin) }

  before do
    sign_in admin

    35.times { create(:client) }
    clients = Client.all(limit: 35)

    3.times do
      clients.each do |client|
        create(:account, client: client)
      end
    end
    accounts = Account.all(limit: 35)
    3.times do
      accounts.each do |account|
        create(:deposit,
               value_date: Date.today,
               sum: 1000,
               rate: 2.5,
               withholding: 12,
               close_date: Date.today + 3.months)
      end
    end

    visit operations_path
  end

  it { should have_selector('title', text: I18n.t(:list_all, model: Operation.model_name.human.pluralize)) }
  it { should have_selector('h2',    text: I18n.t(:list_all, model: Operation.model_name.human.pluralize)) }

  describe "pagination" do

    it { should have_selector('div.pagination') }

    it "should list each operation" do
      Client.accounts_sum.paginate(page: 1).each do |client|
        page.should have_selector('td', text: client.firstname)
        page.should have_selector('td', text: client.lastname)
        page.should have_selector('td', text: number_to_currency(client.accounts_balance))
      end
    end
  end

  after(:all) { Client.delete_all }
end
