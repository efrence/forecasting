require 'rails_helper'

RSpec.describe StreetAddress, type: :model do
  it_behaves_like "redis_persistable"
end
