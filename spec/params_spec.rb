describe RenameParams::Params do

  subject(:params) { RenameParams::Params.new(a: 'A', b: 'B') }

  describe '#rename' do
    context 'when params includes given key' do

      before { params.rename(:a, :c) }

      it { expect(params[:a]).to be_nil }
      it { expect(params[:b]).to eq 'B' }
      it { expect(params[:c]).to eq 'A' }
    end

    context 'params does not include key' do
      before { params.rename(:c, :d) }

      it { expect(params[:a]).to eq 'A' }
      it { expect(params[:b]).to eq 'B' }
      it { expect(params[:c]).to be_nil }
      it { expect(params[:d]).to be_nil }
    end
  end

  describe '#convert' do
    context 'when using an Enum converter' do
      before { params.convert(:b, { 'B' => 'D' }) }

      it { expect(params[:b]).to eq 'D' }
    end

    context 'when using a lambda converter' do
      before { params.convert(:b, ->(old_value) { old_value * 2 }) }

      it { expect(params[:b]).to eq 'BB' }
    end
  end
end