require 'spec_helper'

feature "Admin Pages" do

  before(:all) { 30.times { create(:admin) } }
  after(:all)  { Admin.delete_all }

  let(:admin) { create(:admin) }

  background do
    sign_in_with_browser(admin)
    visit admins_path
  end

  scenario "Has index page with correct links and titles" do
    expect(page).to have_title(full_title(I18n.t(:list_all, model: Admin.model_name.human.pluralize)))
    expect(page).to have_selector('h1', text: I18n.t(:list_all, model: Admin.model_name.human.pluralize))
    expect(page).to have_link(I18n.t('links.delete'))
    expect(page).to have_link(I18n.t('links.delete'), href: admin_path(Admin.first))
    expect(page).not_to have_link(I18n.t('links.delete'), href: admin_path(admin))
  end

  scenario 'Has pagination and lists all admins' do
    expect(page).to have_selector('div.pagination')

    Admin.paginate(page: 1).each do |admin|
      expect(page).to have_selector('li', text: admin.full_name)
    end
  end

  scenario 'Admin can be deleted via delete link' do
    expect { click_link(I18n.t('links.delete'), match: :first) }.to change(Admin, :count).by(-1)
  end

  scenario "Has profile page with correct titles" do
    visit admin_path(admin)
    expect(page).to have_selector('h1', text: admin.full_name)
    expect(page).to have_title(full_title(admin.full_name))
  end

  scenario "Has edit page with correct titles" do
    visit edit_admin_path(admin)

    expect(page).to have_selector('h2', text: I18n.t(:edit, model: Admin.model_name.human))
    expect(page).to have_title(full_title(I18n.t(:edit, model: Admin.model_name.human)))
  end

  scenario 'Update with invalid information generated errors' do
    visit edit_admin_path(admin)
    fill_in I18n.t('activerecord.attributes.admin.firstname'), with: ""
    click_button I18n.t('helpers.submit.update', model: Admin.model_name.human)
    expect(page).to have_content(I18n.t(:form_errors))
  end

  scenario 'Update with valid information with success' do
    visit edit_admin_path(admin)

    fill_in I18n.t('activerecord.attributes.admin.firstname'), with: "Newfirstname"
    fill_in I18n.t('activerecord.attributes.admin.lastname'),  with: "Newlastname"
    fill_in I18n.t('activerecord.attributes.admin.email'),     with: "new@example.com"
    fill_in I18n.t('activerecord.attributes.admin.password'),  with: admin.password
    fill_in I18n.t(:confirm_password), with: admin.password
    click_button I18n.t('helpers.submit.update', model: Admin.model_name.human)

    expect(page).to have_title(I18n.t(:list_all, model: Client.model_name.human.pluralize))
    expect(page).to have_selector('div.alert.alert-success')
    expect(page).to have_link(I18n.t('links.sign_out'), href: signout_path)
    admin.reload
    expect(admin.firstname).to eq "Newfirstname"
    expect(admin.lastname).to eq "Newlastname".upcase
    expect(admin.email).to eq "new@example.com"
  end
end
