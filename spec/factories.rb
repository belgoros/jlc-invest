FactoryGirl.define do
  factory :client do
    sequence(:firstname)  { |n| "Fname #{n}" }
    sequence(:lastname)  { |n| "FLastName #{n}" }
    sequence(:street)  { |n| "street #{n}" }
    sequence(:house)  { |n| "1#{n}" }
    sequence(:zipcode)  { |n| "1#{n}" }
    sequence(:city)  { |n| "city #{n}" }
    sequence(:country)  { |n| "country #{n}" }    
  end
  
  factory :operation do
    operation_type Operation::TRANSACTIONS[0]    
    sum 1000
    duration 3
    rate 1.5
    client
  end
  
end

