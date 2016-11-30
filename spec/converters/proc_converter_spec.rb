describe RenameParams::Converters::ProcConverter do

  subject(:converter) { RenameParams::Converters::ProcConverter.new(->(value) { value.to_i * 100 }) }

  describe '#convert' do
    it { expect(converter.convert(1)).to eq 100 }
    it { expect(converter.convert(2)).to eq 200 }
  end
end