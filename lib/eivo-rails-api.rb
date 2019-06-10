# frozen_string_literal: true

require 'raven'

require 'oj'
require 'multi_json'
require 'fast_jsonapi'

require 'kaminari'

require_relative 'eivo-rails-api/engine'

module EIVO
  class << self
    def configure(application)
      application.config.load_defaults 5.2
      application.config.api_only = true
      
      application.config.require_master_key = true

      application.config.generators do |g|
        g.orm :active_record, primary_key_type: :uuid
      end

      require_relative "eivo-rails-api/environments/#{Rails.env}"
      EIVO::Environment.send(Rails.env)
    end
  end
end
