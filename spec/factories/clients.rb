FactoryBot.define do
  factory :client do
    firstname  { Faker::Name.first_name }
    lastname   { Faker::Name.last_name }
    street     { Faker::Address.street_name }
    house      { Faker::Address.building_number}
    zipcode    { Faker::Address.zip_code }
    city       { Faker::Address.city }
    country    { Faker::Address.default_country }
    phone      { Faker::PhoneNumber.phone_number }

    factory :invalid_client do
      lastname { nil }
    end
  end
end
