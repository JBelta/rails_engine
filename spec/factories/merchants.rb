FactoryBot.define do
  factory :merchant do
    name {Faker::Name.name}

    trait :with_items do
      after :create do |merchant|
        create_list(:item, 3, merchant: merchant)
      end 
    end
  end
end
