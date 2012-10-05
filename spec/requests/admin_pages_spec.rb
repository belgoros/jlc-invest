require 'spec_helper'

describe "Admin Pages" do
  subject { page }
  
  describe "profile page" do
    # Code to make a user variable
    let(:user) { FactoryGirl.create(:admin) }
    before { visit admin_path(user) }

    it { should have_selector('h1',    text: user.full_name) }
    it { should have_selector('title', text: user.full_name) }
  end  

  describe "signup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
    
    describe "with invalid information" do    
      it "should not create a user" do
        expect { click_button submit }.not_to change(Admin, :count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Firstname",with: "Jean"
        fill_in "Lastname", with: "Dupont"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(Admin, :count).by(1)
      end
    end
    
    
  end
  
  
    
end
