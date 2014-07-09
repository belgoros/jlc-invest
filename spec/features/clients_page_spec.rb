require 'spec_helper'

feature "Clients Page" do

  let(:admin)  { create(:admin) }
  #Create  client to be first to click on, see the spec
  # "Client accounts page can be accessed via Edit link"
  let(:client) { create(:client, lastname: "lastname_to_click") }

  background do
    sign_in_with_browser(admin)
    visit clients_path
  end

  before(:all) do
    Client.delete_all
    31.times { create(:client) }
  end

  scenario "Has index page with correct titles" do
    expect(page).to have_title(full_title(I18n.t(:list_all, model: Client.model_name.human.pluralize)))
    expect(page).to have_selector('h2',    text: I18n.t(:list_all, model: Client.model_name.human.pluralize))
  end

  scenario 'Has pagination and lists all clients' do
    expect(page).to have_selector('div.pagination')

    Client.paginate(page: 1).each do |client|
      expect(page).to have_selector('td', text: client.firstname)
      expect(page).to have_selector('td', text: client.lastname)
      expect(page).to have_selector('td', text: client.phone)
    end
  end

  scenario 'Has delete links' do
    expect(page).to have_link(I18n.t('links.delete'))
    expect(page).to have_link(I18n.t('links.delete'), href: client_path(Client.first))
  end

  scenario 'Client can be deleted via delete link' do
    expect { click_link(I18n.t('links.delete'),  match: :first) }.to change(Client, :count).by(-1)
  end

  scenario 'Has links to edit a client' do
    expect(page).to have_link(I18n.t('links.edit'))
  end

  scenario 'Client accounts page can be accessed via Edit link' do
    first_client = Client.first
    within('.table-striped') do
      click_link first_client.lastname
      expect(page).to have_title(full_title(first_client.full_name))
    end
  end
end
