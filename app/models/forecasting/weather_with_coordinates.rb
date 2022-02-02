module Forecasting
  class WeatherWithCoordinates
    include ActiveModel::Attributes

    attribute :coordinates
    attribute :temperature_in_celsius

    include RedisPersistable
    include ActiveModel::Validations

    attribute_expireat :temperature_in_celsius, lambda { Time.now + 30.minutes }
    redis_find_by :coordinates

    validates_presence_of :temporal_temperature_in_celsius, :temporal_coordinates
  end
end
