require 'spec_helper'

describe Client do
  subject(:client) { build(:client) }

  it { should respond_to(:firstname) }
  it { should respond_to(:lastname) }
  it { should respond_to(:phone) }
  it { should respond_to(:house) }
  it { should respond_to(:box) }
  it { should respond_to(:zipcode) }
  it { should respond_to(:city) }
  it { should respond_to(:country) }
  it { should respond_to(:accounts) }

  it { should be_valid }

  describe "when first name is not present" do
    before { client.firstname = " " }
    it { should_not be_valid }
  end

  describe "when first name is too long" do
    before { client.firstname = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when last name is not present" do
    before { client.lastname = " " }
    it { should_not be_valid }
  end

  describe "when last name is too long" do
    before { client.lastname = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when the client with the same first name and last name already exists" do
    before do
      the_same_client = client.dup
      the_same_client.save
    end

    it { should_not be_valid }
  end

  describe "when street is not present" do
    before { client.street = " " }
    it { should_not be_valid }
  end

  describe "when house number is not present" do
    before { client.house = " " }
    it { should_not be_valid }
  end

  describe "when  zip code is not present" do
    before { client.zipcode = " " }
    it { should_not be_valid }
  end

  describe "when  city is not present" do
    before { client.city = " " }
    it { should_not be_valid }
  end

  describe "when country is not present" do
    before { client.country = " " }
    it { should_not be_valid }
  end

  describe "when street is too long" do
    before { client.street = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when  house number is too long" do
    before { client.house = "1" * 6 }
    it { should_not be_valid }
  end

  describe "when zip code is too long" do
    before { client.zipcode = "1" * 16 }
    it { should_not be_valid }
  end

  describe "when city is too long" do
    before { client.city = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when country is too long" do
    before { client.country = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when phone number is too long" do
    before { client.phone = "a" * 51 }
    it { should_not be_valid }
  end

  describe "account associations" do

    before { client.save }
    let!(:old_account) { create(:account, client: client) }
    let!(:new_account) { create(:account, client: client) }

    it "should destroy associated accounts" do
      accounts = client.accounts
      client.destroy
      accounts.each do |account|
        Account.find_by_id(account.id).should be_nil
      end
    end
  end

  describe '#account_balance' do
    before do
      Account.delete_all
      @client_with_no_accoounts = create(:client)
    end

    context 'when a client has no accounts' do
      specify 'his accounts balance should be zero' do
        expect(@client_with_no_accoounts.accounts_balance).to eq(0)
      end
    end

    context 'when a client has an account with an operation' do
      before do
        @account = create(:account)
        create(:deposit, account: @account, close_date: Date.today + 6.months, sum: 1000, rate: 12, withholding: 12 )
      end

      specify 'his accounts balance should be greater than zero' do
        expect(@account.client.accounts_balance).to be > 0
      end
    end
  end

end
