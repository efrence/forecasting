class ForecastingController < ApplicationController
  before_action :ensure_json_request, only: [:current_weather]

  # GET /forecasting/new
  def new; end

  # GET /forecasting/current_weather
  def current_weather
    address = params.permit!.dig("forecasting","address")
    geo_service = Forecasting::GeocodingService.new(address: address)
    zipcode = geo_service.get_zipcode
    if zipcode.blank?
      return render :json => {error: "Not a valid address"}, status: :not_found
    end

    weather_service = Forecasting::OpenweatherService.new(zipcode: zipcode)
    temperature = weather_service.get_temperature

    render :json => {address: address, zipcode: zipcode, temp_c: temperature}
  end

  private

  def ensure_json_request
    return if request.content_type == 'application/json'

    return render :json => {error: 'include Content-type header with application/json value' }, :status => 406
  end
end
