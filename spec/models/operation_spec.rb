require 'rails_helper'

RSpec.describe Operation, :type => :model do

  let(:client) { create(:client) }
  let(:account) { create(:account, client: client) }

  subject(:deposit_operation) {build(:deposit,
                                      account: account,
                                      close_date: Date.today + 6.months,
                                      sum: 1000,
                                      rate: 12,
                                      withholding: 12) }

  it { is_expected.to respond_to(:operation_type) }
  it { is_expected.to respond_to(:duration) }
  it { is_expected.to respond_to(:rate) }
  it { is_expected.to respond_to(:sum) }
  it { is_expected.to respond_to(:value_date) }
  it { is_expected.to respond_to(:interests) }
  it { is_expected.to respond_to(:total) }
  it { is_expected.to respond_to(:account_id) }
  it { is_expected.to respond_to(:account) }
  it { is_expected.to respond_to(:close_date) }
  it { is_expected.to respond_to(:withholding) }

  describe '#account' do
    subject { super().account }
    it { is_expected.to eq(account) }
  end

  it { is_expected.to be_valid }

  describe "when account_id is not present" do
    before { deposit_operation.account_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when value date is not present" do
    before { deposit_operation.value_date = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when operation type is not present" do
    before { deposit_operation.operation_type = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when sum is not present" do
    before { deposit_operation.sum = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when sum format is not valid" do
    sums = %w[0 1,75 -12]
    sums.each do |wrong_sum|
      before { deposit_operation.sum = wrong_sum }
      it { is_expected.not_to be_valid }
    end
  end

  #Deposit or Remission operation

  describe "when deposit or remission" do
    context "calculates the duration after save" do
      subject { create(:deposit, sum: 1000, rate: 12, withholding: 12, account: account, value_date: Date.today, close_date: Date.today + 182.days )}

      describe '#duration' do
        subject { super().duration }
        it { is_expected.to be_within(1).of(182) }
      end
    end

    context "when rate is not present" do
      before { deposit_operation.rate = nil }
      it { is_expected.not_to be_valid }
    end

    context "when withholding is not present" do
      before { deposit_operation.withholding = nil }
      it { is_expected.not_to be_valid }
    end

    context "when close date is not present" do
      before { deposit_operation.close_date = nil }
      it { is_expected.not_to be_valid }
    end

    context "when rate format is not valid" do
      rates = %w[0 1,75 -12]
      rates.each do |rate|
        before { deposit_operation.rate = rate }
        it { is_expected.not_to be_valid }
      end
    end

    context "when withholding format is not valid" do
      values = %w[0 1,75  -12]
      values.each do |value|
        before { deposit_operation.withholding = value }
        it { is_expected.not_to be_valid }
      end
    end

    context "calculates interests" do
      subject { create(:deposit,
                        account: account,
                        sum: 1000,
                        rate: 12,
                        withholding: 12,
                        value_date: Date.today,
                        close_date: Date.today + 6.months )}
      describe '#total' do
        subject { super().total }
        it { is_expected.not_to be_blank }
      end

      describe '#interests' do
        subject { super().interests }
        it { is_expected.not_to be_blank }
      end
    end

    context "calculate interests and total correctly" do
      subject { create(:deposit,
                        account: account,
                        sum: 1000,
                        rate: 12,
                        withholding: 12,
                        value_date: Date.today,
                        close_date: Date.today + 182.days )}

      describe '#interests' do
        subject { super().interests }
        it {is_expected.to be_within(0.01).of(52.66)}
      end

      describe '#total' do
        subject { super().total }
        it {is_expected.to be_within(0.01).of(1052.66)}
      end
    end
  end

  #  Withdrawal operation

  describe "withdrawal operation" do
    before(:each) {deposit_operation.save }

    context "when requested sum does not exceed the balance" do
      subject { build(:withdrawal, account: account, sum: 500) }
      it { is_expected.to be_valid }
    end

    context "interests should not be calculated" do
      subject { build(:withdrawal, account: account, sum: 500) }

      describe '#interests' do
        subject { super().interests }
        it { is_expected.to be_nil }
      end
    end

    context "when requested sum exceeds the balance" do
      subject { build(:withdrawal, account: account, sum: 10000) }
      it { is_expected.not_to be_valid }
    end
  end
end
