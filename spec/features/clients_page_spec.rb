require 'spec_helper'

feature "Clients Page" do

  given(:admin)   { create(:admin)  }
  given!(:client) { create(:client) }

  background do
    sign_in_with_browser(admin)
    visit clients_path
  end

  scenario "Has index page with correct titles" do
    expect(page).to have_title(full_title(I18n.t(:list_all, model: Client.model_name.human.pluralize)))
    expect(page).to have_selector('h2',    text: I18n.t(:list_all, model: Client.model_name.human.pluralize))
  end

  scenario 'Has delete links' do
    expect(page).to have_link(I18n.t('links.delete'))
    expect(page).to have_link(I18n.t('links.delete'), href: client_path(client))
  end

  scenario 'Client can be deleted via delete link' do
    visit clients_path
    expect { click_link(I18n.t('links.delete'),  match: :first) }.to change(Client, :count).by(-1)
  end

  scenario 'Has links to edit a client' do
    expect(page).to have_link(I18n.t('links.edit'))
  end

  scenario 'Client accounts page can be accessed via Edit link' do
    within('.table-striped') do
      click_link client.lastname
      expect(page).to have_title(full_title(client.full_name))
    end
  end
end
