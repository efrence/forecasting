module Forecasting
  class ZipcodeWithTemperature
    include ActiveModel::Attributes

    attribute :zipcode
    attribute :temperature

    include RedisPersistable
    include ActiveModel::Validations

    attribute_expireat :temperature, lambda { Time.now + 30.minutes }
    redis_find_by :zipcode

    validates_presence_of :temporal_zipcode, :temporal_temperature
  end
end

