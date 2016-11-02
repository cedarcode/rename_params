module Support
  module Macros

    # Example:
    #   spawn_controller(TestController) do
    #     rename :a, to: :b
    #
    #     def index
    #       head :ok
    #     end
    #   end
    #
    #  Will generate code below:
    #   class TestController < ActionController::Base
    #     rename :a, to: :b
    #
    #     def index
    #       head :ok
    #     end
    #   end
    # And will let a controller instance accessible through a
    # `controller` method within the test.
    def spawn_controller(klass, &block)
      Object.instance_eval { remove_const klass } if Object.const_defined?(klass)
      Object.const_set(klass, Class.new(ActionController::Base))
      Object.const_get(klass).class_eval(&block) if block_given?

      set_controller!(klass.to_s.constantize)
    end

    def controller
      @controller
    end

    private

    def set_controller!(klass)
      req = ActionDispatch::Request.new({})
      res = klass.make_response!(req)
      @controller = klass.new
      @controller.set_response!(res)
      @controller.params = params
      @controller.run_callbacks(:process_action)
    end
  end
end

