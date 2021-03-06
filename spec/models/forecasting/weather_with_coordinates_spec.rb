require 'rails_helper'

RSpec.describe Forecasting::WeatherWithCoordinates, type: :model do
  it_behaves_like "redis_persistable"
  it 'has a primary key' do
    expect(described_class.primary_key).to eq(:coordinates)
  end
end
