describe RenameParams::Macros, type: :controller do
  describe '.rename' do

    context 'when not filtering' do
      let(:default_params) { { controller: 'anonymous', action: 'index' } }
      before { routes.draw { get index: 'anonymous#index' } }

      context 'when just renaming params' do
        controller(ActionController::Base) do
          rename :username, to: :login

          def index
            head :ok
          end
        end

        it 'renames username to login' do
          get :index, params: { username: 'aperson' }
          expected = default_params.merge(login: 'aperson')
          expect(controller.params).to eq ActionController::Parameters.new(expected)
        end
      end

      context 'when converting values' do
        context 'and using enum converter' do
          controller(ActionController::Base) do
            rename :admin, to: :role, convert: { true: ['admin'], false: [] }

            def index
              head :ok
            end
          end

          it 'renames admin to role and converts value' do
            get :index, params: { admin: 'true' }
            expected = default_params.merge(role: ['admin'])
            expect(controller.params).to eq ActionController::Parameters.new(expected)
          end
        end

        context 'and using a Proc converter' do
          controller(ActionController::Base) do
            rename :amount_due, to: :amount_due_in_cents, convert: ->(value) { value.to_i * 100 }

            def index
              head :ok
            end
          end

          it 'renames amount_due to amount_due_in_cents and converts value' do
            get :index, params: { amount_due: 100 }
            expected = default_params.merge(amount_due_in_cents: 10000)
            expect(controller.params).to eq ActionController::Parameters.new(expected)
          end
        end
      end
    end
  end
end