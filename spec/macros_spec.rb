describe RenameParams::Macros do

  describe '.rename' do
    context 'when not converting values' do
      let(:params) { { username: 'aperson' } }
      before do
        spawn_controller(:UsersController) { rename :username, to: :login }
      end

      it 'renames username to login' do
        expected = { login: 'aperson' }
        expect(controller.params).to eq ActionController::Parameters.new(expected)
      end
    end

    context 'when converting values' do
      context 'and using enum converter' do
        let(:params) { { admin: 'true' } }
        before do
          spawn_controller(:UsersController) do
            rename :admin, to: :role, convert: { true: ['admin'], false: [] }
          end
        end

        it 'renames admin to role and converts value' do
          expected = { role: ['admin'] }
          expect(controller.params).to eq ActionController::Parameters.new(expected)
        end
      end

      context 'and using a Proc converter' do
        let(:params) { { amount_due: 100 } }
        before do
          spawn_controller(:UsersController) do
            rename :amount_due, to: :amount_due_in_cents, convert: ->(value) { value * 100 }
          end
        end

        it 'renames admin to role and converts value' do
          expected = { amount_due_in_cents: 10000 }
          expect(controller.params).to eq ActionController::Parameters.new(expected)
        end
      end
    end
  end
end