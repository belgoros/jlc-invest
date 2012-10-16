require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1', text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }

    describe "signin" do
      before { visit signin_path }

      describe "with invalid information" do
        before { click_button "Sign in" }

        it { should have_selector('title', text: 'Sign in') }
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      end

      describe "with valid information" do
        let(:admin) { FactoryGirl.create(:admin) }
        before { sign_in admin }

        it { should have_selector('title', text: admin.full_name) }
        it { should have_link('Operations', href: operations_path) }
        it { should have_link('Users', href: admins_path) }
        it { should have_link('Profile', href: admin_path(admin)) }
        it { should have_link('Settings', href: edit_admin_path(admin)) }
        it { should have_link('Sign out', href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end

      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:admin) { FactoryGirl.create(:admin) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_admin_path(admin)
          fill_in "Email", with: admin.email
          fill_in "Password", with: admin.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
          end
        end
      end

      describe "in the Admins controller" do

        describe "visiting the edit page" do
          before { visit edit_admin_path(admin) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put admin_path(admin) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the Admin index" do
          before { visit admins_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end
    end

    describe "as wrong user" do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:wrong_user) { FactoryGirl.create(:admin, email: "wrong@example.com") }
      before { sign_in admin }

      describe "visiting Admins#edit page" do
        before { visit edit_admin_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Admins#update action" do
        before { put admin_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

end