# frozen_string_literal: true

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
      result = {
        params: event.payload[:params].except('controller', 'action', 'format'),
        request_id: event.payload[:request_id]
      }

      result[:user_id] = event.payload[:user_id] if event.payload[:user_id]
      result[:organization_id] = event.payload[:organization_id] if event.payload[:organization_id]

      # https://github.com/roidrage/lograge/pull/307
      if event.respond_to?(:allocations)
        result[:allocations] = event.allocations
      end

      result
    end
  end
end
