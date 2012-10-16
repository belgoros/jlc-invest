require 'spec_helper'

describe "Client Operation Pages" do
  subject { page }
  
  let(:admin) { FactoryGirl.create(:admin) }
  let(:client) { FactoryGirl.create(:client) }  

  before(:each) { sign_in admin }
  
  describe "index" do
    before { visit operations_path }    
    
    it { should have_selector('title', text: 'All operations') }
    it { should have_selector('h1', text: 'All operations') }

    
#    before(:all) { 31.times { FactoryGirl.create(:operation, client: client) } }
#    after(:all) { client.operations.delete_all }
#
#    describe "pagination" do
#
#      it { should have_selector('div.pagination') }
#
#      it "should list each operation" do
#        Operation.paginate(page: 1).each do |operation|
#          page.should have_selector('td', text: operation.value_date.to_s)
#        end
#      end
#    end
  end
  
end
