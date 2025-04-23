# spec/factories/shared_bins.rb
FactoryBot.define do
  factory :shared_bin do
    association :bin
    association :shared_with, factory: :user

    # Avoid self-sharing by default
    after(:build) do |shared_bin|
      # Reassign bin's user if needed
      if shared_bin.bin.user_id == shared_bin.shared_with_id
        shared_bin.shared_with = create(:user)
      end
    end
  end
end
