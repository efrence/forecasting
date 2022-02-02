require 'rails_helper'

RSpec.describe Forecasting::GeocodingService, type: :service do
  let(:ar_validations_methods) { [
    :__callbacks?, :__callbacks, :_validate_callbacks, :model_name,
    :validation_context, :_validators, :_validators?, :_run_validate_callbacks,
    :received_message?, :should_not, :as_null_object, :__id__, :equal?,
    :instance_eval, :__send__
  ] }
  let(:attribute_accessor_methods) { [:address, :address= ] }
  let(:address) { 'New York, NY 10004, USA' }
  let(:country_codes) { ['us','fr'] }
  let(:statue_of_liberty_coordinates) { [40.7127281, -74.0060152] }
  let(:geo_service) { described_class.new(address: address, country_codes: country_codes) }

  it 'contains 1 public method: get_coordinates' do
    own_methods = described_class.new.public_methods(false) - ar_validations_methods - attribute_accessor_methods
    expect(own_methods).to eq([:get_coordinates])
  end

  it 'get_coordinates return 2-dimensional array with floating numbers' do
    result = geo_service.get_coordinates
    expect(result).to be_a(Array)
    expect(result.size).to eq(2)
    expect(result.first).to be_a(Float)
    expect(result.second).to be_a(Float)
    expect(result).to eq(statue_of_liberty_coordinates)
  end

  it 'country_codes argument is optional' do
    result = described_class.new(address: address).get_coordinates
    expect(result).to eq(statue_of_liberty_coordinates)
  end

  it 'address argument is mandatory' do
    result = described_class.new(address: nil).get_coordinates
    expect(result).to eq(["Address can't be blank"])
  end
end
