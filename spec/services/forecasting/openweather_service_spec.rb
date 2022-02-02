require 'rails_helper'

RSpec.describe Forecasting::OpenweatherService, type: :service do
  let(:ar_validations_methods) { [
    :__callbacks?, :__callbacks, :_validate_callbacks, :model_name,
    :validation_context, :_validators, :_validators?, :_run_validate_callbacks,
    :received_message?, :should_not, :as_null_object, :__id__, :equal?,
    :instance_eval, :__send__
  ] }
  let(:attribute_accessor_methods) { [:zipcode, :zipcode= ] }
  let(:zipcode) { 10005 }
  let(:country_code) { 'US' }
  let(:temperature_scale) { 'c' }
  let(:weather_service) { described_class.new(zipcode: zipcode, country_code: country_code, temperature_scale: temperature_scale ) }

  it 'contains 1 public method: get_temperature' do
    own_methods = described_class.new.public_methods(false) - ar_validations_methods - attribute_accessor_methods
    expect(own_methods).to eq([:get_temperature])
  end

  it 'get_coordinates return 1 floating number' do
    result = weather_service.get_temperature
    expect(result).to be_a(Float)
    expect(result.to_i.between?(-20, 40)).to eq(true)
  end

  it 'country_code argument is optional' do
    result = described_class.new(zipcode: zipcode).get_temperature
    expect(result.to_i.between?(-20, 40)).to eq(true)
  end

  it 'zipcode argument is mandatory' do
    result = described_class.new(zipcode: nil).get_temperature
    expect(result).to eq(["Zipcode can't be blank"])
  end
end

