require 'spec_helper'

describe "Operation Pages" do
  subject { page }
  
  let(:admin) { create(:admin) }
  let(:client) { create(:client) }

  before(:each) { sign_in admin }
  
  describe "index" do
    before { visit operations_path }    
    
    it { should have_selector('title', text: 'All operations') }
    it { should have_selector('h1', text: 'All operations') }

    
=begin
    before(:all) do
      35.times do
        create(:deposit, client: client, value_date: Date.today, close_date: Date.today + 3.months,
               sum: 1000,rate:1.25)
      end
    end
    after(:all) { client.operations.delete_all }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each operation" do
        Operation.paginate(page: 1).each do |operation|
          page.should have_selector('td', text: operation.value_date.to_s)
        end
      end
    end
=end
  end
  
end
