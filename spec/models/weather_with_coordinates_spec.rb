require 'rails_helper'

RSpec.describe WeatherWithCoordinates, type: :model do
  it_behaves_like "redis_persistable"
end
