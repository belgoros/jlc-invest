Given(/^I am logged in$/) do
  admin = create(:admin)
  sign_in admin
end

When(/^I visit the clients page$/) do
  visit clients_path
end

Then(/^I should see the list of clients$/) do
  pending # express the regexp above with the code you wish you had
end
