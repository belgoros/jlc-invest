require 'spec_helper'

describe Operation do

  let(:client) { create(:client, firstname: 'Jean', lastname: 'Dupont') }

  before { @operation = build(:deposit, client: client) }

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
  it { should respond_to(:close_date) }

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
  
  describe "when deposit or remission" do
    describe "if duration is not present" do
      before { @operation.duration = nil }      
      it { should_not be_valid }
    end
    
    describe "when rate is not present" do
      before { @operation.rate = nil }
      it { should_not be_valid }
    end
    
    describe "when close date is not present" do
      before { @operation.close_date = nil }
      it { should_not be_valid }
    end   
    
    describe "when rate format is not valid" do
      rates = %w[0 1,75 azerty -12]
      rates.each do |valid_rate|
        before { @operation.rate = valid_rate }
        it { should_not be_valid }
      end
    end 
    
    describe "calculates interests" do
      before { @operation.save }
      its(:total) { should_not be_blank }
      its(:interests) { should_not be_blank }
    end    
  end

  describe "when value date is not present" do
    before { @operation.value_date = nil }
    it { should_not be_valid }
  end

  describe "when operation type is not present" do
    before { @operation.operation_type = nil }
    it { should_not be_valid }
  end  

  describe "when sum is not present" do
    before { @operation.sum = '' }
    it { should_not be_valid }
  end  

  describe "when sum format is not valid" do
    sums = %w[0 1,75 azerty -12]
    sums.each do |wrong_sum|
      before { @operation.sum = wrong_sum }
      it { should_not be_valid }
    end
  end  
  
  describe "withdrawal operation" do
    before(:each) {@operation.save }
    
    context "when requested sum does not exceed the balance" do
      subject { build(:withdrawal, client: client) }
      it { should be_valid }
    end
    
    context "interests should not be calculated" do
      subject { build(:withdrawal, client: client) }
      its(:interests) { should be_nil }
    end
     
    context "when requested sum exceeds the balance" do
      subject { build(:withdrawal, client: client, sum: 5000) }
      it { should_not be_valid }
    end
  end  

end
