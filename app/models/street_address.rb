class StreetAddress
  include ActiveModel::Attributes

  attribute :address
  attribute :zipcode

  include RedisPersistable
  include ActiveModel::Validations

  redis_find_by :address
  validates_presence_of :temporal_address, :temporal_zipcode
end
