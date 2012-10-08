require 'spec_helper'

describe Operation do
  
  let(:client) { FactoryGirl.create(:client) }
  
  before {
    @operation = client.operations.build(operation_type: Operation::TRANSACTIONS[0], duration: 5, rate: 1.20, sum: 10000)
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
  
  describe "calculate interests and total" do
    before {@operation.save}
    its(:interests) {should eq(@operation.sum * (@operation.rate/100 * @operation.duration/12))}
    its(:total) {should eq(@operation.sum + @operation.interests)}
  end
  
  
end
