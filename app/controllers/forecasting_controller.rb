class ForecastingController < ApplicationController
  before_action :ensure_json_request, only: [:current_weather]

  # GET /forecasting/new
  def new; end

  # GET /forecasting/current_weather
  def current_weather
    address = params.permit!.dig("forecasting","address")

    if address.blank?
      return render :json => {error: "Not a valid address"}, status: :bad_request
    end

    geo_service = Forecasting::GeocodingService.new(address: address)
    @zipcode = geo_service.get_zipcode

    if @zipcode.blank?
      return render :json => {error: "Not a valid address"}, status: :not_found
    end

    @cached = false
    @not_found = false

    @temperature = get_temp_cached_value
    unless @temperature # skip
      retrieve_temp
      if @not_found
        return render :json => {message: 'Resource not found' }, :status => 404
      end
    else
      @cached = true
    end

    if @temperature
      cache_values
    end

    render :json => {address: address, zipcode: @zipcode, temp_c: @temperature, cached: @cached}
  end

  private

  def retrieve_temp
    begin
      weather_service = Forecasting::OpenweatherService.new(zipcode: @zipcode)
      @temperature = weather_service.get_temperature
    rescue Faraday::ResourceNotFound
      # TODO log error
      @not_found = true
    end
  end

  def get_temp_cached_value
    redis_hash = Forecasting::ZipcodeWithTemperature.find_by_zipcode @zipcode
    redis_hash["temperature"]
  end

  def cache_values
    zipcode_lookup = Forecasting::ZipcodeWithTemperature.new
    zipcode_lookup.temporal_zipcode = @zipcode
    zipcode_lookup.temporal_temperature = @temperature
    zipcode_lookup.save!
  end

  def ensure_json_request
    return if request.content_type == 'application/json'

    return render :json => {error: 'include Content-type header with application/json value' }, :status => 406
  end
end
