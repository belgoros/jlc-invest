require 'spec_helper'

describe "Account operations pages" do

  subject { page }

  let(:admin) { create(:admin) }
  let(:client) { create(:client) }
  let(:account) { create(:account, client: client) }

  before do
    sign_in admin
    31.times { create(:deposit, sum: 1000, rate: 2.5, close_date: Date.today + 2.months, withholding: 21, account: account) }
    visit account_path(account)
  end

  after { account.operations.delete_all }

  describe "page" do
    it { should have_selector('h1', text: client.full_name) }
    it { should have_selector('h2', text: I18n.t(:list_all, model: Operation.model_name.human.pluralize)) }
    it { should have_selector('title', text: full_title(client.full_name)) }
    it { should have_link(I18n.t('links.new', model: Operation.model_name.human), href: new_account_operation_path(account)) }
    it { should have_link(I18n.t('links.back_to_list'), href: client_path(client)) }
    it { should have_selector('th', text: I18n.t(:account_balance))}

    describe "pagination" do
      it { should have_selector('div.pagination') }

      it "should list each account operation" do
        Operation.paginate(page: 1).each do |operation|
          page.should have_selector('td', text: operation.id.to_s)
          page.should have_link(I18n.t('links.printing'), href: account_operation_path(operation.account, operation, format: :pdf))
          page.should have_link(I18n.t('links.edit'), href: edit_account_operation_path(account, operation))
          page.should have_link(I18n.t('links.delete'), href: account_operation_path(account, operation))
        end
      end
    end
  end

end