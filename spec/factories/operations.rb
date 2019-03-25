FactoryBot.define do
  factory :operation do
    value_date { Date.today }
    account

    factory :deposit do
      operation_type { Operation::DEPOSIT }
    end

    factory :remission do
      operation_type { Operation::REMISSION }
    end

    factory :withdrawal do
      operation_type { Operation::WITHDRAWAL }
    end
  end
end
