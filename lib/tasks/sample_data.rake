namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_clients
    make_accounts
    make_operations
  end
end

def make_users
  Admin.create!(firstname: 'Big', lastname: 'Boss',
                email: 's.cambour@gmail.com',
                password: 'admin123',
                password_confirmation: 'admin123')

  35.times do |n|
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    email = Faker::Internet.email
    password = "password"
    Admin.create!(firstname: firstname,
                  lastname: lastname,
                  email: email,
                  password: password,
                  password_confirmation: password)
  end
end


def make_clients
  Faker::Config.locale = :fr

  35.times do |n|
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    street = Faker::Address.street_name
    house = Faker::Address.building_number
    city = Faker::Address.city
    zipcode = Faker::Address.zip_code
    country = Faker::Address.default_country
    phone = Faker::PhoneNumber.phone_number
    Client.create!(firstname: firstname,
                   lastname: lastname,
                   street: street,
                   house: house,
                   zipcode: zipcode,
                   city: city,
                   country: country,
                   phone: phone)
  end

end

def make_accounts
  clients = Client.all(limit: 35)
  3.times do
    clients.each do |client|
      client.accounts.create!
    end
  end
end

def make_operations
  range = 100..1000
  accounts = Account.all(limit: 35)
  3.times do
    accounts.each do |account|
      account.operations.create!(value_date: Date.today,
      operation_type: Operation::DEPOSIT,
      sum: 1000.0 + range.to_a.sample,
      rate: account.id/10.0 + 1,
      withholding: 12,
      close_date: Date.today + account.id.months)
    end
  end
end
