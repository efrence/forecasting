FactoryBot.define do
  factory(:street_address) do
    address { Faker::Internet.address }
    zipcode { Faker::Internet.zipcode }
  end
end
