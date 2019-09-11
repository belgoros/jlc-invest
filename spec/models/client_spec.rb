require 'rails_helper'

RSpec.describe Client, :type => :model do
  subject(:client) { build(:client) }

  it { is_expected.to respond_to(:firstname) }
  it { is_expected.to respond_to(:lastname) }
  it { is_expected.to respond_to(:phone) }
  it { is_expected.to respond_to(:house) }
  it { is_expected.to respond_to(:box) }
  it { is_expected.to respond_to(:zipcode) }
  it { is_expected.to respond_to(:city) }
  it { is_expected.to respond_to(:country) }
  it { is_expected.to respond_to(:accounts) }

  it { is_expected.to be_valid }

  describe "when first name is not present" do
    before { client.firstname = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when first name is too long" do
    before { client.firstname = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when last name is not present" do
    before { client.lastname = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when last name is too long" do
    before { client.lastname = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when the client with the same first name and last name already exists" do
    before do
      the_same_client = client.dup
      the_same_client.save
    end

    it { is_expected.not_to be_valid }
  end

  describe "when street is not present" do
    before { client.street = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when house number is not present" do
    before { client.house = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when  zip code is not present" do
    before { client.zipcode = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when  city is not present" do
    before { client.city = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when country is not present" do
    before { client.country = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when street is too long" do
    before { client.street = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when  house number is too long" do
    before { client.house = "1" * 6 }
    it { is_expected.not_to be_valid }
  end

  describe "when zip code is too long" do
    before { client.zipcode = "1" * 16 }
    it { is_expected.not_to be_valid }
  end

  describe "when city is too long" do
    before { client.city = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when country is too long" do
    before { client.country = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when phone number is too long" do
    before { client.phone = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "account associations" do

    before { client.save }
    let!(:old_account) { create(:account, client: client) }
    let!(:new_account) { create(:account, client: client) }

    it "should destroy associated accounts" do
      accounts = client.accounts
      client.destroy
      accounts.each do |account|
        expect(Account.find_by_id(account.id)).to be_nil
      end
    end
  end

  describe '#account_balance' do
    before do
      Account.delete_all
      @client_with_no_accounts = create(:client)
    end

    context 'when a client has no accounts' do
      specify 'his accounts balance should be zero' do
        expect(@client_with_no_accounts.accounts_balance).to eq(0)
      end
    end

    context 'when a client has an account with an operation' do
      before do
        @client = create(:client)
        @account = create(:account, client: @client)
        create(:deposit, account: @account, close_date: Date.today + 6.months, sum: 1000, rate: 12, withholding: 12 )
      end

      specify 'his accounts balance should be greater than zero' do
        expect(@client.accounts_balance).to be > 0
      end
    end
  end

end
