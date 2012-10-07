namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users   
  end
end

def make_users
  
  99.times do |n|
    firstname  = Faker::Name.first_name
    lastname = Faker::Name.last_name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    Admin.create!(firstname: firstname,
      lastname: lastname,
      email:    email,
      password: password,
      password_confirmation: password)
  end
  
end