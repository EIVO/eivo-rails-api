# frozen_string_literal: true

require 'lograge'

if Rails.env.staging? || Rails.env.production?
  Rails.application.configure do
    config.colorize_logging = false

    config.lograge.enabled = true
    config.lograge.formatter = ::Lograge::Formatters::Raw.new
    config.lograge.base_controller_class = [
      'ActionController::API',
      'ActionController::Base'
    ]

    config.lograge.ignore_actions = ['EIVO::StatusController#index']

    config.lograge.custom_options = ->(event) do
      result = event.payload || {}

      if result[:params]
        result[:params] = result[:params].except('controller', 'action', 'format')
      end

      # https://github.com/roidrage/lograge/pull/307
      if event.respond_to?(:allocations)
        result[:allocations] = event.allocations
      end

      result
    end
  end
end
