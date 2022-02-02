require 'rails_helper'

RSpec.describe ZipcodeWithCoordinates, type: :model do
  it_behaves_like "redis_persistable"
end
