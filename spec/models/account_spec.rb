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
  it { should respond_to(:balance) }


  describe "account number" do
    before { @account.save }
    its(:acc_number) { should_not be_nil }

    it "has a generated number increased by one" do
      last = client.accounts.last
      new_account = create(:account, client: client)
      (new_account.acc_number.split('-').last.to_i - last.acc_number.split('-').last.to_i).should == 1
    end
  end
end
