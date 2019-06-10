# frozen_string_literal: true

require 'raven'

Raven.configure do |config|
  config.environments = %w[ staging production ]
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
end
