describe RenameParams::Macros::Move, type: :controller do
  context 'with :root' do
    controller(ActionController::Base) do
      move :name, to: :root, namespace: :billing_contact

      def update
        head :ok
      end
    end

    describe 'move' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'moves billing_contact[:name] to root' do
        put :update, with_params(billing_contact: { name: 'Marcelo' })
        expect(controller.params).to eq(build_params(controller: 'anonymous', action: 'update', billing_contact: {}, name: 'Marcelo'))
      end
    end
  end

  context 'with existent nested key' do
    controller(ActionController::Base) do
      move :street, to: :billing_contact, namespace: [:billing_contact, :address]

      def update
        head :ok
      end
    end

    describe 'move' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'moves billing_contact[:address][:street] to billing_contact[:street]' do
        put :update, with_params(billing_contact: { address: { street: '123 St' } })
        expect(controller.params).to eq(build_params(controller: 'anonymous', action: 'update', billing_contact: { address: {}, street: '123 St' }))
      end
    end
  end

  context 'with non existent nested key' do
    controller(ActionController::Base) do
      move :name, to: :contact, namespace: :billing_contact

      def update
        head :ok
      end
    end

    describe 'move' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'moves billing_contact[:name] to contact[:name]' do
        put :update, with_params(billing_contact: { name: 'Marcelo' })
        expect(controller.params).to eq( build_params(controller: 'anonymous', action: 'update', billing_contact: {}, contact: { name: 'Marcelo' }))
      end
    end
  end

  context 'with non existent deep nested key' do
    controller(ActionController::Base) do
      move :name, to: [:contact, :info], namespace: :billing_contact

      def update
        head :ok
      end
    end

    describe 'move' do
      before { routes.draw { get 'update' => 'anonymous#update' } }

      it 'moves billing_contact[:name] to contact[:info][:name]' do
        put :update, with_params(billing_contact: { name: 'Marcelo' })
        expect(controller.params).to eq(build_params(controller: 'anonymous', action: 'update', billing_contact: {}, contact: { info: { name: 'Marcelo' } }))
      end
    end
  end
end
