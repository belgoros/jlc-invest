require 'spec_helper'

feature "Authentication" do
  let(:admin) { create(:admin) }

  background do
    visit signin_path
  end

  scenario "Page has correct titles if signed in" do
    expect(page).to have_selector('h1',    text: I18n.t(:connection))
    expect(page).to have_title(full_title(I18n.t(:connection)))
  end

  scenario 'Does not sign in with invalid information' do
    click_button I18n.t('links.sign_in')
    expect(page).to have_title(I18n.t(:connection))
    expect(page).to have_selector('div.alert.alert-danger', text: I18n.t(:invalid_login))
  end

  scenario 'Sign in with valid information' do
    sign_in_with_browser(admin)

    expect(page).to have_title(full_title(admin.full_name))
    expect(page).to have_link(I18n.t('links.home'), href: root_path)
    expect(page).to have_link(I18n.t('links.operations'), href: operations_path)
    expect(page).to have_link(I18n.t('links.profile'), href: admin_path(admin))
    expect(page).to have_link(I18n.t('links.settings'), href: edit_admin_path(admin))
    expect(page).to have_link(I18n.t('links.sign_out'), href: signout_path)
    expect(page).to_not have_link(I18n.t('links.sign_in'), href: signin_path)
  end

  scenario 'Has sign out link if signed in' do
    sign_in_with_browser(admin)
    click_link I18n.t('links.sign_out')
    expect(page).to have_link(I18n.t('links.sign_in'))
  end

  scenario 'Authorized to edit for signed in admin' do
    sign_in_with_browser(admin)
    visit edit_admin_path(admin)
    expect(page).to have_title(full_title(I18n.t('links.edit', model: Admin.model_name.human)))
  end

  scenario 'Not authorized to edit for non-signed in admin' do
    sign_in_with_browser(admin)
    sign_out_with_browser
    visit edit_admin_path(admin)
    expect(page).to have_title(full_title(I18n.t(:connection)))
  end
end
