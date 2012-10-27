require 'spec_helper'

describe Operation do

  let(:client) { create(:client) }

  before { @deposit_operation = build(:deposit, client: client, close_date: Date.today + 6.months, sum: 1000,
                                      rate: 12, interests_tax: 12) }

  subject { @deposit_operation }

  it { should respond_to(:operation_type) }
  it { should respond_to(:duration) }
  it { should respond_to(:rate) }
  it { should respond_to(:sum) }
  it { should respond_to(:value_date) }
  it { should respond_to(:interests) }
  it { should respond_to(:total) }
  it { should respond_to(:client_id) }
  it { should respond_to(:client) }
  it { should respond_to(:close_date) }
  it { should respond_to(:withholding) }

  its(:client) { should == client }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to client_id" do
      expect do
        Operation.new(client_id: client.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when client_id is not present" do
    before { @deposit_operation.client_id = nil }
    it { should_not be_valid }
  end
  
  describe "when value date is not present" do
    before { @deposit_operation.value_date = nil }
    it { should_not be_valid }
  end

  describe "when operation type is not present" do
    before { @deposit_operation.operation_type = nil }
    it { should_not be_valid }
  end  

  describe "when sum is not present" do
    before { @deposit_operation.sum = '' }
    it { should_not be_valid }
  end  

  describe "when sum format is not valid" do
    sums = %w[0 1,75 azerty -12]
    sums.each do |wrong_sum|
      before { @deposit_operation.sum = wrong_sum }
      it { should_not be_valid }
    end
  end  
  
  #Deposit or Remission operation
  
  describe "when deposit or remission" do
    context "calculates the duration after save" do
      subject { create(:deposit, sum: 1000, rate: 12, client: client, value_date: Date.today, close_date: Date.today + 6.months )}
      its(:duration) { should == 182 }
    end
    
    context "when rate is not present" do
      before { @deposit_operation.rate = nil }
      it { should_not be_valid }
    end
    
    context "when withholding is not present" do
      before { @deposit_operation.withholding = nil }
      it { should_not be_valid }
    end
    
    context "when close date is not present" do
      before { @deposit_operation.close_date = nil }
      it { should_not be_valid }
    end   
    
    context "when rate format is not valid" do
      rates = %w[0 1,75 azerty -12]
      rates.each do |rate|
        before { @deposit_operation.rate = rate }
        it { should_not be_valid }
      end
    end 
    
    context "when withholding format is not valid" do
      values = %w[0 1,75 azerty -12]
      values.each do |value|
        before { @deposit_operation.withholding = value }
        it { should_not be_valid }
      end
    end 
    
    context "calculates interests" do
      subject { create(:deposit, client: client, sum: 1000, rate: 12, interests_tax: 12, 
            value_date: Date.today, close_date: Date.today + 6.months )}
      its(:total) { should_not be_blank }
      its(:interests) { should_not be_blank }
    end

    context "calculate interests and total correctly" do
      subject { create(:deposit, client: client, sum: 1000, rate: 12, value_date: Date.today, close_date: Date.today + 6.months )}
      its(:interests) {should be_within(0.01).of(59.84)}
      its(:total) {should be_within(0.01).of(1059.84)}
    end
  end
  
  #  Withdrawal operation
  
  describe "withdrawal operation" do
    before(:each) {@deposit_operation.save }
    
    context "when requested sum does not exceed the balance" do
      subject { build(:withdrawal, client: client, sum: 500) }
      it { should be_valid }
    end
    
    context "interests should not be calculated" do
      subject { build(:withdrawal, client: client, sum: 500) }
      its(:interests) { should be_nil }
    end
     
    context "when requested sum exceeds the balance" do      
      subject { build(:withdrawal, client: client, sum: 10000) }
      it { should_not be_valid }
    end
  end  

end
