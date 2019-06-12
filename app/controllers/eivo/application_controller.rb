# frozen_string_literal: true

module EIVO
  class ApplicationController < ::ActionController::API

    include EIVO::Concerns::Exception
    include EIVO::Concerns::Rendering
    include EIVO::Concerns::Pagination

    # doesn't work
    # rescue_from ::ActiveRecord::RecordNotFound, with: :render_not_found
    # rescue_from ::ActionController::ParameterMissing, with: :render_parameter_missing
    # rescue_from ::StandardError, with: :render_internal_server_error

    def process_action(*args)
      begin
        super
      rescue ::ActiveRecord::RecordNotFound => e
        render_not_found(e)
      rescue ::ActionController::ParameterMissing => e
        render_parameter_missing(e)
      rescue ::StandardError => e
        if Rails.env.development?
          raise e
        else
          ::Raven.capture_exception(e)
        end
        render_internal_server_error(e)
      end
    end

  end
end
