require 'spec_helper'

describe Admin do
  before { @admin = Admin.new(firstname: "Jean", 
          lastname: "Dupont",
          password: "admin123",
          password_confirmation: "admin123",
          email: "admin@skynet.be")
          }

  subject { @admin }

  it { should respond_to(:firstname) }
  it { should respond_to(:lastname) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }  
  it { should respond_to(:email) } 
  
  it { should respond_to(:authenticate) }
  
  it { should be_valid }  
  
  describe "when first name is not present" do
    before { @admin.firstname = " " }
    it { should_not be_valid }
  end
  
  describe "when first name is too long" do
    before { @admin.firstname = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when last name is not present" do
    before { @admin.lastname = " " }
    it { should_not be_valid }
  end
  
  describe "when last name is too long" do
    before { @admin.lastname = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when password is not present" do
    before { @admin.password = @admin.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @admin.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @admin.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @admin.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @admin.email = invalid_address
        @admin.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @admin.email = valid_address
        @admin.should be_valid
      end      
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @admin.dup
      user_with_same_email.email = @admin.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @admin.password = @admin.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    before { @admin.save }
    let(:found_user) { Admin.find_by_email(@admin.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@admin.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  describe "remember token" do
    before { @admin.save }
    its(:remember_token) { should_not be_blank }
  end

end
