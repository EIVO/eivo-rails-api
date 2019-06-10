# frozen_string_literal: true

module EIVO
  class Engine < ::Rails::Engine
    ActiveSupport::Inflector.inflections(:en) do |inflect|
      inflect.acronym 'EIVO'
    end
  end
end
