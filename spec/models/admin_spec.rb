require 'spec_helper'

describe Admin, :type => :model do
  subject(:admin) { build(:admin) }

  it { is_expected.to respond_to(:firstname) }
  it { is_expected.to respond_to(:lastname) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:authenticate) }

  it { is_expected.to be_valid }

  describe "when first name is not present" do
    before { admin.firstname = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when first name is too long" do
    before { admin.firstname = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when last name is not present" do
    before { admin.lastname = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when last name is too long" do
    before { admin.lastname = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when password is not present" do
    before { admin.password = admin.password_confirmation = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { admin.password_confirmation = "mismatch" }
    it { is_expected.not_to be_valid }
  end

  describe "when password confirmation is empty" do
    before { admin.password_confirmation = ' ' }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { admin.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. double_dots@foo..bar]
      addresses.each do |invalid_address|
        admin.email = invalid_address
        expect(admin).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        admin.email = valid_address
        expect(admin).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      admin_with_same_email = admin.dup
      admin_with_same_email.email = admin.email.upcase
      admin_with_same_email.save
    end

    it { is_expected.not_to be_valid }
  end

  describe "with a password that's too short" do
    before { admin.password = admin.password_confirmation = "a" * 5 }
    it { is_expected.to be_invalid }
  end

  describe "return value of authenticate method" do
    before { admin.save }
    let(:found_admin) { Admin.find_by_email(admin.email) }

    describe "with valid password" do
      it { is_expected.to eq(found_admin.authenticate(admin.password)) }
    end

    describe "with invalid password" do
      let(:admin_for_invalid_password) { found_admin.authenticate("invalid") }

      it { is_expected.not_to eq(admin_for_invalid_password) }
      specify { expect(admin_for_invalid_password).to be_falsey }
    end
  end

  describe "when saved" do
    before { admin.save }

    describe '#remember_token' do
      subject { super().remember_token }
      it { is_expected.not_to be_blank }
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      admin.email = mixed_case_email
      admin.save
      expect(admin.reload.email).to eq mixed_case_email.downcase
    end
  end
end
