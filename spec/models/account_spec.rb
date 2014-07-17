require 'spec_helper'

describe Account, :type => :model do
  let(:client) { create(:client) }

  subject(:account) { build(:account, client: client) }

  describe '#client' do
    subject { super().client }
    it { is_expected.to eq(client) }
  end

  it { is_expected.to be_valid }

  it { is_expected.to respond_to(:acc_number) }
  it { is_expected.to respond_to(:client_id) }
  it { is_expected.to respond_to(:client) }
  it { is_expected.to respond_to(:operations) }
  it { is_expected.to respond_to(:balance) }


  describe "account number" do
    before { account.save }

    describe '#acc_number' do
      subject { super().acc_number }
      it { is_expected.not_to be_nil }
    end

    it "has a generated number increased by one" do
      last = client.accounts.last
      new_account = create(:account, client: client)
      expect(new_account.acc_number.split('-').last.to_i - last.acc_number.split('-').last.to_i).to eq(1)
    end
  end
end
