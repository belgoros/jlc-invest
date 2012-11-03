require 'spec_helper'

describe Account do
  let(:client) { create(:client) }
  before { @account = build(:account, client: client) }

  subject { @account }
  
  its(:client) { should == client }

  it { should be_valid }
  
  it { should respond_to(:acc_number) }
  it { should respond_to(:client_id) }
  it { should respond_to(:client) }
  it { should respond_to(:operations) } 
  

  describe "has a generated number" do
    before { @account.save }    
    its(:acc_number) { should_not be_nil }
  end  
  
end
