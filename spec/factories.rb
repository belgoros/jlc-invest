require 'faker'

FactoryGirl.define do
  factory :admin do
    firstname  { Faker::Name.first_name }
    lastname   { Faker::Name.last_name }
    email      { Faker::Internet.email }
    password "Admin123"
    password_confirmation "Admin123"
  end

  factory :client do
    firstname  { Faker::Name.first_name }
    lastname   { Faker::Name.last_name }
    street     { Faker::Address.street_name }
    house      { Faker::Address.building_number}
    zipcode    { Faker::Address.zip_code }
    city       { Faker::Address.city }
    country    { Faker::Address.country }
    phone      { Faker::PhoneNumber.phone_number }
  end

  factory :account do
    client
  end

  factory :operation do
    value_date Date.today
    account

    factory :deposit do
      operation_type Operation::DEPOSIT
    end

    factory :remission do
      operation_type Operation::REMISSION
    end

    factory :withdrawal do
      operation_type Operation::WITHDRAWAL
    end
  end
end
