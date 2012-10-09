require 'spec_helper'

describe Client do
  before { @client = Client.new(firstname: "Jean", 
      lastname: "Dupont",
      phone: "069-123456",
      street: "Rue du Chateau",
      house: "37",
      zipcode: "7500",
      city: "Tournai",
      country: "Belgique") }

  subject { @client }
  
  it { should respond_to(:firstname) }
  it { should respond_to(:lastname) }
  it { should respond_to(:phone) }
  it { should respond_to(:house) }
  it { should respond_to(:box) }
  it { should respond_to(:zipcode) }
  it { should respond_to(:city) }
  it { should respond_to(:country) }  
  it { should respond_to(:operations) }  
  
  it { should be_valid }
  
  describe "when first name is not present" do
    before { @client.firstname = " " }
    it { should_not be_valid }
  end
  
  describe "when first name is too long" do
    before { @client.firstname = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when last name is not present" do
    before { @client.lastname = " " }
    it { should_not be_valid }
  end
  
  describe "when last name is too long" do
    before { @client.lastname = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when the client with the same first name and last name already exists" do
    before do
      the_same_client = @client.dup
      the_same_client.lastname = @client.lastname.downcase
      the_same_client.save
    end

    it { should_not be_valid }
  end
  
  describe "when street is not present" do
    before { @client.street = " " }
    it { should_not be_valid }
  end
  
  describe "when house number is not present" do
    before { @client.house = " " }
    it { should_not be_valid }
  end
  
  describe "when  zip code is not present" do
    before { @client.zipcode = " " }
    it { should_not be_valid }
  end
  
  describe "when  city is not present" do
    before { @client.city = " " }
    it { should_not be_valid }
  end
  
  describe "when country is not present" do
    before { @client.country = " " }
    it { should_not be_valid }
  end
  
  describe "when street is too long" do
    before { @client.street = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when  house number is too long" do
    before { @client.house = "1" * 6 }
    it { should_not be_valid }
  end
  
  describe "when zip code is too long" do
    before { @client.zipcode = "1" * 6 }
    it { should_not be_valid }
  end
  
  describe "when city is too long" do
    before { @client.city = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when country is too long" do
    before { @client.country = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "operation associations" do

    before { @client.save }
    
    let!(:older_operation) do 
      FactoryGirl.create(:operation, client: @client, value_date: 3.days.ago)
    end
    let!(:newer_operation) do
      FactoryGirl.create(:operation, client: @client, value_date: 1.hour.ago)
    end

    it "should have the right operations in the right order" do
      @client.operations.should == [newer_operation, older_operation]
    end
    
    
    it "should destroy associated operations" do
      operations = @client.operations
      @client.destroy
      operations.each do |operation|
        Operation.find_by_id(operation.id).should be_nil
      end
    end  
    
    
  end
  
  
end
