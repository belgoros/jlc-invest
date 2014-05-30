require 'spec_helper'

describe "Authentication" do
  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: I18n.t(:connection)) }
    it { should have_title(full_title(I18n.t(:connection))) }

    describe "signin" do
      before { visit signin_path }

      describe "with invalid information" do
        before { click_button I18n.t('links.sign_in') }

        it { should have_title(I18n.t(:connection)) }
        it { should have_selector('div.alert.alert-error', text: I18n.t(:invalid_login)) }
      end

      describe "with valid information" do
        let(:admin) { create(:admin) }
        before { sign_in admin }

        it { should have_title(full_title(admin.full_name)) }
        it { should have_link(I18n.t('links.home'), href: root_path) }
        it { should have_link(I18n.t('links.operations'), href: operations_path) }
        it { should have_link(I18n.t('links.profile'), href: admin_path(admin)) }
        it { should have_link(I18n.t('links.settings'), href: edit_admin_path(admin)) }
        it { should have_link(I18n.t('links.sign_out'), href: signout_path) }
        it { should_not have_link(I18n.t('links.sign_in'), href: signin_path) }

        describe "followed by signout" do
          before { click_link I18n.t('links.sign_out')}
          it { should have_link(I18n.t('links.sign_in')) }
        end

      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:admin) { create(:admin) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_admin_path(admin)
          fill_in I18n.t('activerecord.attributes.admin.email'), with: admin.email
          fill_in I18n.t('activerecord.attributes.admin.password'), with: admin.password
          click_button I18n.t('links.sign_in')
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should have_title(full_title(I18n.t('links.edit', model: Admin.model_name.human)))
          end
        end
      end

      describe "in the Admins controller" do

        describe "visiting the edit page" do
          before { visit edit_admin_path(admin) }
          it { should have_title(full_title(I18n.t(:connection))) }
        end

        describe "submitting to the update action" do
          before { put admin_path(admin) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the Admin index" do
          before { visit admins_path }
          it { should have_title(full_title(I18n.t(:connection))) }
        end
      end
    end

    describe "as wrong user" do
      let(:admin) { create(:admin) }
      let(:wrong_user) { create(:admin, email: "wrong@example.com") }
      before { sign_in admin }

      describe "visiting Admins#edit page" do
        before { visit edit_admin_path(wrong_user) }
        it { should_not have_title(full_title(I18n.t(:edit, model: Admin.model_name.human ))) }
      end

      describe "submitting a PUT request to the Admins#update action" do
        before { put admin_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
