FactoryGirl.define do
  factory :admin do
    sequence(:firstname)  { |n| "firstname #{n}" }
    sequence(:lastname)   { |n| "lastname #{n}" }
    sequence(:email)      { |n| "person_#{n}@example.com" }
    password "Admin123"
    password_confirmation "Admin123"
  end

  factory :client do
    sequence(:firstname)  { |n| "firstname_#{n}" }
    sequence(:lastname)   { |n| "lastname_#{n}" }
    sequence(:street)     { |n| "street_#{n}" }
    sequence(:house)      { |n| "1#{n}" }
    sequence(:zipcode)    { |n| "1#{n}" }
    sequence(:city)       { |n| "city_#{n}" }
    sequence(:country)    { |n| "country_#{n}" }
    sequence(:phone)      { |n| "078-#{n}" }
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
