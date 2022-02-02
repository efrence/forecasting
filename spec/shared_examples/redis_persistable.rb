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
end
