FactoryGirl.define do
  factory :admin do
    sequence(:firstname) { |n| "firstname #{n}" }
    sequence(:lastname) { |n| "lastname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "Admin123"
    password_confirmation "Admin123"
  end

  factory :client do
    sequence(:firstname) { |n| "firstname #{n}" }
    sequence(:lastname) { |n| "lastname #{n}" }
    sequence(:street) { |n| "street #{n}" }
    sequence(:house) { |n| "1#{n}" }
    sequence(:zipcode) { |n| "1#{n}" }
    sequence(:city) { |n| "city #{n}" }
    sequence(:country) { |n| "country #{n}" }
  end

  factory :operation do
    operation_type Operation::TRANSACTIONS[0]
    sum 1000
    duration 6
    rate 12
    value_date Date.today
    client
  end

  factory :withdrawal, class: Operation do
    operation_type Operation::TRANSACTIONS[1]
    sum 1000
    value_date Date.today
    client
  end

end

