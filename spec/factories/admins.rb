FactoryBot.define do
  factory :admin do
    firstname  { Faker::Name.first_name }
    lastname   { Faker::Name.last_name }
    email      { Faker::Internet.email }
    password {'secret' }
    password_confirmation { 'secret' }
  end
end
