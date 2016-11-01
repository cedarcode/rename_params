describe RenameParams::Params do

  subject(:params) { RenameParams::Params.new(a: 'A', b: 'B') }

  describe '#rename' do
    context 'when params includes given key' do

      before { params.rename(:a, to: :c) }

      it { expect(params[:a]).to be_nil }
      it { expect(params[:c]).to eq 'A' }

      context 'when using an Enum converter' do
        before { params.rename(:b, to: :d, convert: { 'B' => 'D' }) }

        it { expect(params[:b]).to be_nil }
        it { expect(params[:d]).to eq 'D' }
      end

      context 'when using a lambda converter' do
        before { params.rename(:b, to: :d, convert: ->(old_value) { old_value * 2 }) }

        it { expect(params[:b]).to be_nil }
        it { expect(params[:d]).to eq 'BB' }
      end
    end

    context 'params does not include key' do
      before { params.rename(:c, to: :d) }

      it { expect(params[:a]).to eq 'A' }
      it { expect(params[:b]).to eq 'B' }
      it { expect(params[:c]).to be_nil }
      it { expect(params[:d]).to be_nil }
    end
  end
end