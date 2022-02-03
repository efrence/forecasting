shared_examples_for 'redis_persistable' do
  let(:resource) { create(described_class.name.underscore) }

  describe '#add_persisted?' do
    it 'should add a new persisted? method' do
      expect(resource.persisted?).to eq(true)
    end
  end

  describe '#add_valid?' do
    it 'should add a new valid? method' do
      expect(resource.valid?).to eq(true)
    end
  end

  describe '#add_find_by_primary_key' do
    it 'should add a new valid? method' do
      attribute_name = described_class.primary_key
      result = described_class.send("find_by_#{attribute_name}", resource.send("temporal_#{attribute_name}"))
      expect(result).to be_a(Hash)
      expect(result[attribute_name]).to_not be_nil
    end
  end
end
