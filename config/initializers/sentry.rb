# frozen_string_literal: true

require 'raven'

Raven.configure do |config|
  config.environments = %w[staging production]
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  config.excluded_exceptions = [
    'ActionController::RoutingError',
    'ActionController::InvalidAuthenticityToken'
  ]
end
