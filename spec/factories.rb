FactoryGirl.define do
  factory :client do
    sequence(:firstname)  { |n| "Fname #{n}" }
    sequence(:lastname)  { |n| "FLastName #{n}" }
    sequence(:street)  { |n| "street #{n}" }
    sequence(:house)  { |n| "1#{n}" }
    sequence(:zip)  { |n| "1#{n}" }
    sequence(:city)  { |n| "city #{n}" }
    sequence(:country)  { |n| "country #{n}" }

    
    factory :admin do
      admin true
    end
  end
  
  factory :operation do
    type "deposit"
    value_date Date.today
    sum 1000
    duration 3
    rate 1.2
    client
  end
  
end

