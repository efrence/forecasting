module Forecasting
  class GeocodingService

    def initialize(address: nil, country_codes: ['us'])
      @address = address
      @country_codes = country_codes
    end

    def call
      result_set = Geocoder.search(@address, params: {countrycodes: @country_codes.join(',')})
      if result_set && result_set.size > 0
        return result_set.first
      end
      nil
    end

    def get_coordinates
      result = call
      if result
        return result.coordinates
      end
      nil
    end
  end
end
