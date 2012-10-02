require 'spec_helper'

describe "Admin Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end
  
  describe "profile page" do
    # Code to make a user variable
    let(:user) { FactoryGirl.create(:admin) }
    before { visit admin_path(user) }

    it { should have_selector('h1',    text: user.full_name) }
    it { should have_selector('title', text: user.full_name) }
  end
end
