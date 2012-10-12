require 'spec_helper'

describe "Client Pages" do
  subject { page }
  
  describe "index" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:client) { FactoryGirl.create(:client) }
    
    before(:each) do
      sign_in admin
      visit clients_path
    end

    it { should have_selector('title', text: 'All clients') }
    it { should have_selector('h1',    text: 'All clients') }
    
    before(:all) { 31.times { FactoryGirl.create(:client) } }
    after(:all)  { Client.delete_all }
    
    describe "pagination" do      

      it { should have_selector('div.pagination') }
      
      it "should list each client" do
        Client.paginate(page: 1).each do |client|
          page.should have_selector('li', text: client.full_name)
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
      it {should have_link('edit')}
    end  
  end
  
  describe "edit" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:client) { FactoryGirl.create(:client) }
    before do 
      sign_in admin
      visit edit_client_path(client)
    end
    
    describe "page" do
      it { should have_selector('h1',    text: "Update client profile") }
      it { should have_selector('title', text: "Edit client") }  
      it { should have_link('Back to List', href: clients_path)}
    end    
  end
  
  describe "show page" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:client) { FactoryGirl.create(:client) }
    before do 
      sign_in admin
      visit client_path(client)
    end
    
    describe "page" do
      it { should have_selector('h1',    text: client.full_name) }
      it { should have_selector('title', text: client.full_name) }  
      it { should have_link('Back to List', href: clients_path)}
    end
    
  end

  describe "new client page" do
    let(:admin) { FactoryGirl.create(:admin) }
    let(:submit) { "Create client" }
    before do
      sign_in admin
      visit new_client_path
    end

    describe "with valid information" do
      it { should have_selector('h1',    text: "New client") }
      it { should have_selector('title', text: "New client") }
      it { should have_link('Back to List', href: clients_path)}

      before do
        fill_in "Firstname",with: "Jean"
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
