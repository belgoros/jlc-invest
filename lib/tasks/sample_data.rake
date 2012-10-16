namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_clients
  end
end

def make_users
  Admin.create!(firstname: 'Big', lastname: 'Boss',
                email: 's.cambour@gmail.com',
                password: 'admin123',
                password_confirmation: 'admin123')

  50.times do |n|
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    Admin.create!(firstname: firstname,
                  lastname: lastname,
                  email: email,
                  password: password,
                  password_confirmation: password)
  end
end


def make_clients
  #Faker::Config.locale = :fr

  50.times do |n|
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    street = Faker::Address.street_name
    house = Faker::Address.building_number
    city = Faker::Address.city
    zipcode = Faker::Address.zip_code
    country = Faker::Address.country
    Client.create!(firstname: firstname,
                   lastname: lastname,
                   street: street,
                   house: house,
                   zipcode: zipcode,
                   city: city,
                   country: country)
  end

end
