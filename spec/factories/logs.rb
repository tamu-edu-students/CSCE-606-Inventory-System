FactoryBot.define do
  factory :log do
    user
    action_type { "create" }
    action_date { Time.current }
    description { "Test log entry" }

    trait :with_item do
      association :item
    end

    trait :with_bin do
      association :bin
    end
  end
end