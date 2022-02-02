class WeatherWithCoordinates
  include ActiveModel::Attributes

  attribute :temperature_in_celsius
  attribute :coordinates

  include RedisObjects
  include ActiveModel::Validations

  attribute_expireat :temperature_in_celsius, lambda { Time.now + 30.minutes }

  validates_presence_of :temporal_temperature_in_celsius, :temporal_coordinates
end

