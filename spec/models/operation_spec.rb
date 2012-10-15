require 'spec_helper'

describe Operation do

  let(:client) { FactoryGirl.create(:client) }

  before {
    @operation = FactoryGirl.build(:operation, client: client)
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
    end
    it { should_not be_valid }
  end

  describe "when sum is not present" do
    before { @operation.sum = '' }
    it { should_not be_valid }
  end

  describe "when rate is not present when deposit" do
    before { @operation.rate = '' }
    it { should_not be_valid }
  end

  describe "when rate format is not valid" do
    rates = %w[0 1,75 azerty -12]
    rates.each do |valid_rate|
      before { @operation.rate = valid_rate }
      it { should_not be_valid }
    end
  end

  describe "when sum format is not valid" do
    sums = %w[0 1,75 azerty -12]
    sums.each do |wrong_sum|
      before { @operation.sum = wrong_sum }
      it { should_not be_valid }
    end
  end

  describe "calculates interests and total when deposit" do
    before { @operation.save }
    its(:total) { should_not be_blank }
    its(:interests) { should_not be_blank }
  end
  
  describe "withdrawal operation" do
    before(:each) {@operation.save }
    
    context "when requested sum does not exceed the balance" do
       let(:withdrawal) { FactoryGirl.build(:withdrawal, client: client) }
       subject { withdrawal }
       it { should be_valid }
    end
     
    context "when requested sum exceeds the balance" do
      let(:withdrawal) { FactoryGirl.build(:withdrawal, sum:5000, client: client) }
      subject { withdrawal }
      it { should_not be_valid }
    end
  end  

end
