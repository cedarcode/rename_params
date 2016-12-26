require 'rename_params/macros/rename'

module RenameParams
  module Macros
    extend ActiveSupport::Concern
    include RenameParams::Macros::Rename
  end
end

ActionController::API.send(:include, RenameParams::Macros) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams::Macros) if defined?(ActionController::Base)
