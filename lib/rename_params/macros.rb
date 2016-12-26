module RenameParams
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def rename(*args)
        RenameParams::Macros::Rename.def_rename(self, *args)
      end

      def move(*args)
        RenameParams::Macros::Move.def_move(self, *args)
      end
    end
  end
end

ActionController::API.send(:include, RenameParams::Macros) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams::Macros) if defined?(ActionController::Base)
