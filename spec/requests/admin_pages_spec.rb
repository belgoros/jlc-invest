require 'spec_helper'

describe "Admin Pages" do
  subject { page }

  describe "index" do

    let(:admin) { FactoryGirl.create(:admin) }

    before(:each) do
      sign_in admin
      visit admins_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1', text: 'All users') }

    before(:all) { 30.times { FactoryGirl.create(:admin) } }
    after(:all) { Admin.delete_all }

    describe "pagination" do

      it { should have_selector('div.pagination') }

      it "should list each user" do
        Admin.paginate(page: 1).each do |admin|
          page.should have_selector('li', text: admin.full_name)
        end
      end
    end

    describe "delete links" do
      it { should have_link('delete') }

      it { should have_link('delete', href: admin_path(Admin.first)) }
      it "should be able to delete another user" do
        expect { click_link('delete') }.to change(Admin, :count).by(-1)
      end

      it { should_not have_link('delete', href: admin_path(admin)) }
    end

  end

  describe "profile page" do
    let(:admin) { FactoryGirl.create(:admin) }
    before { visit admin_path(admin) }

    it { should have_selector('h1', text: admin.full_name) }
    it { should have_selector('title', text: admin.full_name) }
  end

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(Admin, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Firstname", with: "Jean"
        fill_in "Lastname", with: "Dupont"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(Admin, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { Admin.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.full_name) }
        it { should have_selector('div.alert.alert-success', text: 'User created') }
        it { should have_link('Sign out') }
      end
    end

  end

  describe "edit" do
    let(:admin) { FactoryGirl.create(:admin) }
    before do
      sign_in admin
      visit edit_admin_path(admin)
    end

    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_firstname) { "NewFirstname" }
      let(:new_lastname) { "NewLastname" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Firstname", with: new_firstname
        fill_in "Lastname", with: new_lastname
        fill_in "Email", with: new_email
        fill_in "Password", with: admin.password
        fill_in "Confirm password", with: admin.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_firstname.capitalize + ' ' + new_lastname.upcase) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { admin.reload.firstname.should == new_firstname.capitalize }
      specify { admin.reload.lastname.should == new_lastname.upcase }
      specify { admin.reload.email.should == new_email }
    end

  end


end
