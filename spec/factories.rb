FactoryGirl.define do
  factory :admin do
    sequence(:firstname) { |n| "firstname #{n}" }
    sequence(:lastname) { |n| "lastname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "Admin123"
    password_confirmation "Admin123"
  end

  factory :client do
    sequence(:firstname) { |n| "firstname_#{n}" }
    sequence(:lastname) { |n| "lastname_#{n}" }
    sequence(:street) { |n| "street_#{n}" }
    sequence(:house) { |n| "1#{n}" }
    sequence(:zipcode) { |n| "1#{n}" }
    sequence(:city) { |n| "city_#{n}" }
    sequence(:country) { |n| "country_#{n}" }
  end

  factory :operation do
    value_date Date.today
    sum 1000
    duration 6
    rate 12
    close_date Date.today + 6.months
    client
    
    factory :deposit do
      operation_type Operation::TRANSACTIONS[0]      
    end
    
    factory :remission do
      operation_type Operation::TRANSACTIONS[2]
    end
    
    factory :withdrawal do
      operation_type Operation::TRANSACTIONS[1]
      sum 1000
      duration nil
      rate nil
    end
    
    
  end 

end

