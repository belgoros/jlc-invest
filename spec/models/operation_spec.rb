require 'spec_helper'

describe Operation do
  
  let(:client) { FactoryGirl.create(:client) }
  
  before {
    @operation = client.operations.build(operation_type: Operation::TRANSACTIONS[0], duration: 5, rate: 1.20, sum: 10000, value_date: Date.today)
  }

  
  subject { @operation }
  
  it { should respond_to(:operation_type) }
  it { should respond_to(:duration) }
  it { should respond_to(:rate) }
  it { should respond_to(:sum) }
  it { should respond_to(:value_date) }    
  it { should respond_to(:interests) }
  it { should respond_to(:total) }
  it { should respond_to(:client_id) }
  it { should respond_to(:client) }
  
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
    before { @operation.client_id = nil }
    it { should_not be_valid }
  end
  
  describe "when operation date is not present" do
    before { @operation.value_date = ' ' }
    it { should_not be_valid }
  end
  
  
  describe "when operation type is not present" do
    before { @operation.operation_type = nil }
    it { should_not be_valid }
  end
  
  describe "when duration is not present when deposit" do
    before do
      @operation.duration = ''
      @operation.operation_type = Operation::TRANSACTIONS[0]
    end
    it { should_not be_valid }
  end
  
  describe "when sum is not present" do
    before { @operation.sum = '' }
    it { should_not be_valid }
  end
  
  describe "when rate is not present" do
    before { @operation.rate = '' }
    it { should_not be_valid }
  end
  
  describe "when rate format is not valid" do
    rates = %w[0 1,75 azerty -12]
    rates.each do |valid_rate|
      before { @operation.rate = valid_rate}
      it { should_not be_valid }
    end
  end
  
  describe "when sum format is not valid" do
    sums = %w[0 1,75 azerty -12]
    sums.each do |valid_sum|
      before { @operation.sum = valid_sum}
      it { should_not be_valid }
    end
  end 
  
  
end
