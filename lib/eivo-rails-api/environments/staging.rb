# frozen_string_literal: true

require_relative 'production'

module EIVO
  class Environment
    def self.staging
      production
    end
  end
end
