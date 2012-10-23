require 'spec_helper'

describe "Operation Pages" do
  subject { page }
  
  let(:admin) { create(:admin) }
  let(:client) { create(:client) }

  before(:each) { sign_in admin }
  
  describe "index" do
    before { visit operations_path }


    before do
      50.times { create(:deposit, client: client, close_date: Date.today + 3.months, sum: 1200, rate: 2) }
    end

    after { client.operations.delete_all}

    describe "page" do
      it { should have_selector('title', text: 'All operations') }
      it { should have_selector('h1', text: 'All operations') }
    end

    #FIX ME
    #describe "operations pagination" do
     # it { should have_selector('div.pagination') }

      #it "should list each operation" do
      #  Operation.paginate(page: 1).each do |operation|
      #    page.should have_selector('td', text: operation.client.firstname)
      #    page.should have_selector('td', text: operation.client.lastname)
      #  end
      #end
    end
  #end
  
end
