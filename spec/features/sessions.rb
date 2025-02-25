FactoryBot.define do
  factory :session do
    association :user
    login_time { Time.current - 1.day }
    logout_time { Time.current }
  end
end
