module Forecasting
  class GeocodingService
    include ActiveModel::Validations
    attr_accessor :address

    validates_presence_of :address

    def initialize(address: nil, country_codes: ['us'])
      @address = address
      @country_codes = country_codes
    end

    def get_coordinates
      result = call
      if result && result.class == Geocoder::Result::Nominatim
        return result.coordinates
      elsif invalid?
        return errors.full_messages
      end
      nil
    end

    private

    def call
      return nil if invalid?

      result_set = Geocoder.search(@address, params: {countrycodes: @country_codes.join(',')})
      if result_set && result_set.size > 0
        return result_set.first
      end
      nil
    end
  end
end
