describe RenameParams::Converters::HashConverter do

  subject(:converter) { RenameParams::Converters::HashConverter.new(a: 'A', b: 'B') }

  describe '#convert' do
    it { expect(converter.convert(:a)).to eq 'A' }
    it { expect(converter.convert(:b)).to eq 'B' }
    it { expect(converter.convert(:c)).to be_nil }
  end
end