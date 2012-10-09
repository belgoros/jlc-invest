FactoryGirl.define do
  factory :admin do
    sequence(:firstname)  { |n| "firstname #{n}" }
    sequence(:lastname)  { |n| "lastname #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}    
    password "Admin123"
    password_confirmation "Admin123"
  end
  
  factory :client do
    sequence(:firstname)  { |n| "firstname #{n}" }
    sequence(:lastname)  { |n| "lastname #{n}" }
    sequence(:street)  { |n| "street #{n}" }
    sequence(:house)  { |n| "1#{n}" }
    sequence(:zipcode)  { |n| "1#{n}" }
    sequence(:city)  { |n| "city #{n}" }
    sequence(:country)  { |n| "country #{n}" }    
  end
  
  factory :operation do
    operation_type Operation::TRANSACTIONS[0]    
    sequence(:sum) { |n| 10 * n }
    sequence(:duration) { |n| 2 * n }
    sequence(:rate) { |n| n * 1.5 }
    sequence(:value_date) { |n | Date.today - n * 2.days}
    client
  end
  
end

