# frozen_string_literal: true

require 'logger'
require 'multi_json'

module EIVO
  class Formatter < ::Logger::Formatter
    def call(severity, timestamp, progname, message)
      json = {
        pid: $PROCESS_ID,
        level: severity,
        timestamp: timestamp.utc.iso8601(3),
        message: message
      }

      if progname
        json[:tag] = progname
      end

      if defined?(::Sidekiq)
        context = ::Sidekiq::Context.current

        if !context.empty?
          json[:context] = context
        end
      end

      MultiJson.dump(json) << "\n"
    end
  end
end
