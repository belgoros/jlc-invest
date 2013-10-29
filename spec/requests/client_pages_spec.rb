require 'spec_helper'

describe "Client Pages" do
  subject { page }

  describe "index" do
    let(:admin) { create(:admin) }
    let(:client) { create(:client) }

    before(:each) do
      sign_in admin
      visit clients_path
    end

    it { should have_selector('title', text: full_title(I18n.t(:list_all, model: Client.model_name.human.pluralize))) }
    it { should have_selector('h2',    text: I18n.t(:list_all, model: Client.model_name.human.pluralize)) }

    before(:all) { 31.times { create(:client) } }
    after(:all) { Client.delete_all }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each client" do
        Client.paginate(page: 1).each do |client|
          page.should have_selector('td', text: client.firstname)
          page.should have_selector('td', text: client.lastname)
        end
      end
    end

    describe "delete links" do
      it { should have_link(I18n.t('links.delete')) }

      it { should have_link(I18n.t('links.delete'), href: client_path(Client.first)) }
      it "should be able to delete a client" do
        expect { click_link(I18n.t('links.delete')) }.to change(Client, :count).by(-1)
      end
    end

    describe "edit links" do
      it { should have_link(I18n.t('links.edit')) }
    end

    describe "operations links" do
      it { should have_link(I18n.t('links.operations')) }
    end
  end

  describe "edit" do
    let(:admin) { create(:admin) }
    let(:client) { create(:client) }
    before do
      sign_in admin
      visit edit_client_path(client)
    end

    describe "page" do
      it { should have_selector('h2',    text: I18n.t(:edit, model: Client.model_name.human)) }
      it { should have_selector('title', text: full_title(I18n.t(:edit, model: Client.model_name.human))) }
      it { should have_link(I18n.t('links.back_to_list'), href: clients_path) }
    end
  end

  describe "client accounts page" do
    let(:admin)   { create(:admin) }
    let(:client)  { create(:client) }
    let(:account) { create(:account, client: client) }
    before do
      sign_in admin
      31.times { create(:account, client: client) }
      visit client_path(client)
    end

    after { client.accounts.delete_all}

    describe "page" do
      it { should have_selector('h2', text: client.full_name) }
      it { should have_selector('title', text: full_title(client.full_name)) }
      it { should have_link(I18n.t('links.back_to_list'), href: clients_path) }
    end

    describe "accounts pagination" do
      it { should have_selector('div.pagination') }

      it "should list each account" do
        Account.paginate(page: 1).each do |account|
          page.should have_selector('td', text: account.acc_number)
          page.should have_link(I18n.t('links.printing'), href: report_account_path(account, format: :pdf))
          page.should have_link(I18n.t('links.delete'), href: account_path(account))
        end
      end
    end
  end

  describe "new client page" do
    let(:admin) { create(:admin) }
    let(:submit) { I18n.t('helpers.submit.create', model: Client.model_name.human) }
    before do
      sign_in admin
      visit new_client_path
    end

    describe "with valid information" do
      it { should have_selector('h1', text: I18n.t(:new, model: Client.model_name.human)) }
      it { should have_selector('title', text: full_title(I18n.t(:new, model: Client.model_name.human))) }
      it { should have_link(I18n.t('links.back_to_list'), href: clients_path) }

      before do
        fill_in I18n.t('activerecord.attributes.client.firstname'), with: "Jean"
        fill_in I18n.t('activerecord.attributes.client.lastname'),  with: "Dupont"
        fill_in I18n.t('activerecord.attributes.client.street'),    with: "Rue Crampon"
        fill_in I18n.t('activerecord.attributes.client.house'),     with: "12A"
        fill_in I18n.t('activerecord.attributes.client.zipcode'),   with: "7500"
        fill_in I18n.t('activerecord.attributes.client.city'),      with: "Tournai"
        fill_in I18n.t('activerecord.attributes.client.country'),   with: "Belgique"
      end

      it "should create a client" do
        expect { click_button submit }.to change(Client, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('title', text: full_title(I18n.t(:list_all, model: Client.model_name.human.pluralize))) }
        it { should have_selector('div.alert.alert-success', text: I18n.t(:created_success, model: Client.model_name.human)) }
        it { should have_link(I18n.t('links.new', model: Client.model_name.human)) }
      end
    end
  end
end
