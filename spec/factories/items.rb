FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Test Item #{n}" }  # ✅ Ensure unique names
    description { "A test description" }
    value { 100 }
    association :bin
    association :location
  end
end
