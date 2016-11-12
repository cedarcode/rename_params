describe RenameParams::Macros, type: :controller do
  describe '.rename' do
    context 'when not converting values' do
      controller(ActionController::Base) do
        rename :username, to: :login

        def index
          head :ok
        end
      end

      before do
        routes.draw { get 'index' => 'anonymous#index' }
        get :index, params: { username: 'aperson' }
      end

      it 'renames username to login' do
        expected = { controller: 'anonymous', action: 'index', login: 'aperson' }
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

        before do
          routes.draw { get 'index' => 'anonymous#index' }
          get :index, params: { admin: 'true' }
        end

        it 'renames admin to role and converts value' do
          expected = { controller: 'anonymous', action: 'index', role: ['admin'] }
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

        before do
          routes.draw { get 'index' => 'anonymous#index' }
          get :index, params: { amount_due: 100 }
        end

        it 'renames admin to role and converts value' do
          expected = { controller: 'anonymous', action: 'index', amount_due_in_cents: 10000 }
          expect(controller.params).to eq ActionController::Parameters.new(expected)
        end
      end
    end
  end
end