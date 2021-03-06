FactoryBot.define do
  factory 'forecasting/weather_with_coordinates' do
    temporal_temperature_in_celsius { Faker::Number.between(from: 0, to: 50) }
    temporal_coordinates { "#{Faker::Address.unique.latitude}, #{Faker::Address.unique.longitude}" }
  end

  factory 'forecasting/zipcode_with_coordinates' do
    temporal_zipcode { Faker::Address.unique.zip_code }
    temporal_coordinates { "#{Faker::Address.unique.latitude}, #{Faker::Address.unique.longitude}" }
  end

  factory 'forecasting/street_address' do
    temporal_address { Faker::Address.unique.street_address }
    temporal_zipcode { Faker::Address.unique.zip_code }
  end
end
