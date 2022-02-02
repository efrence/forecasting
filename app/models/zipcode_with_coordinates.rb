class ZipcodeWithCoordinates
  include ActiveModel::Attributes

  attribute :zipcode
  attribute :coordinates

  include RedisPersistable
  include ActiveModel::Validations

  redis_find_by :zipcode

  validates_presence_of :temporal_zipcode, :temporal_coordinates
end
