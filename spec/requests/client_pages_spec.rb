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

    it { should have_selector('title', text: 'All clients') }
    it { should have_selector('h1', text: 'All clients') }

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
      it { should have_link('delete') }

      it { should have_link('delete', href: client_path(Client.first)) }
      it "should be able to delete a client" do
        expect { click_link('delete') }.to change(Client, :count).by(-1)
      end
    end

    describe "edit links" do
      it { should have_link('edit') }
    end
    
    describe "operations links" do
      it { should have_link('operations') }
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
      it { should have_selector('h1', text: "Update client profile") }
      it { should have_selector('title', text: "Edit client") }
      it { should have_link('Back to List', href: clients_path) }
    end
  end

  describe "client operations page" do
    let(:admin) { create(:admin) }
    let(:client) { create(:client) }
    let(:deposit) { create(:deposit, client: client, close_date: Date.today + 3.months, sum: 1200, rate: 2, withholding: 12) }
    before do
      sign_in admin
      31.times { create(:deposit, client: client, close_date: Date.today + 3.months, sum: 1200, rate: 2, withholding: 12) }
      visit client_path(client)      
    end
    
    after { client.operations.delete_all}

    describe "page" do
      it { should have_selector('h1', text: client.full_name) }
      it { should have_selector('title', text: client.full_name) }
      it { should have_link('Back to List', href: clients_path) }
    end
    
    describe "operations pagination" do
      it { should have_selector('div.pagination') }

      it "should list each operation" do
        Operation.paginate(page: 1).each do |operation|
          page.should have_selector('td', text: operation.sum.to_s)
          page.should have_link('edit', href: edit_client_operation_path(client, operation))
          page.should have_link('delete', href: client_operation_path(client, operation))
        end
      end      
    end

  end

  describe "new client page" do
    let(:admin) { create(:admin) }
    let(:submit) { "Create client" }
    before do
      sign_in admin
      visit new_client_path
    end

    describe "with valid information" do
      it { should have_selector('h1', text: "New client") }
      it { should have_selector('title', text: "New client") }
      it { should have_link('Back to List', href: clients_path) }

      before do
        fill_in "Firstname", with: "Jean"
        fill_in "Lastname", with: "Dupont"
        fill_in "Street", with: "Rue Crampon"
        fill_in "House", with: "12A"
        fill_in "Zipcode", with: "7500"
        fill_in "City", with: "Tournai"
        fill_in "Country", with: "Belgique"
      end

      it "should create a client" do
        expect { click_button submit }.to change(Client, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('title', text: 'All clients') }
        it { should have_selector('div.alert.alert-success', text: 'Client created with success') }
        it { should have_link('New client') }
      end
    end
  end

end
