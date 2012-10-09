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
      it { should have_link('back', href: clients_path)}
    end
  end
end
