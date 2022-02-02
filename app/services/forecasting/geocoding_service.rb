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

    def get_zipcode
      result = call
      if result && result.class == Geocoder::Result::Nominatim
        zipcodes = result.postal_code || result.coordinates.to_zip
        return extract_zipcode zipcodes
      elsif invalid?
        return errors.full_messages
      else
        zipcodes = @address.to_zip
        return extract_zipcode zipcodes
      end
      nil
    end

    private

    def extract_zipcode(zipcodes)
      case zipcodes
      when String
        return zipcodes
      when Array
        return nil if zipcodes.empty?
        return zipcodes.first
      end
      nil
    end

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
