module Forecasting
  class OpenweatherService
    include ActiveModel::Validations
    attr_accessor :zipcode

    validates_presence_of :zipcode

    def initialize(zipcode: nil, temperature_scale: 'c', country_code: 'US' )
      @zipcode = zipcode
      @temperature_scale = temperature_scale
      @country_code = country_code
      @client = OpenWeather::Client.new(
        api_key: Rails.application.credentials[Rails.env.to_sym][:openweather_api_key]
      )
    end

    def get_temperature
      if valid?
        return @client.current_weather(zip: @zipcode, country: @country_code, units: get_units).dig("main","temp")
      end
      nil
    end

    private

    def get_units
      case @temperature_scale
      when 'c'
        return 'metric'
      when 'f'
        return 'imperial'
      else
        return 'standard'
      end
    end
  end
end
