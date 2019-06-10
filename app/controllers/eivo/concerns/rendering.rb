# frozen_string_literal: true

module EIVO
  module Concerns
    module Rendering

      extend ::ActiveSupport::Concern

      def render_success(serializer = nil)
        if serializer
          render json: serializer.serialized_json
        else
          data = {
            data: nil
          }
          render json: ::MultiJson.dump(data)
        end
      end

      def render_unauthorized(exception = nil)
        render_error 'unauthorized', status: :unauthorized
      end

      def render_forbidden(exception = nil)
        render_error 'forbidden', status: :forbidden
      end

      def render_not_found(exception = nil)
        render_error 'not_found', status: :not_found
      end

      def render_internal_server_error(exception)
        render_error 'internal_server_error', status: :internal_server_error
      end

      def render_parameter_missing(exception)
        render_error 'parameter_missing', source: { parameter: exception.param }
      end

      def render_model_errors(errors)
        json_errors = errors.details.map do |attribute, errors|
          errors.map do |error|
            {
              code: error[:error],
              source: {
                parameter: attribute
              },
              status: ::Rack::Utils::SYMBOL_TO_STATUS_CODE[:bad_request].to_s
            }
          end
        end

        render_errors json_errors.flatten
      end

      def render_error(code, status: :bad_request, source: nil)
        render_errors([{
          code: code,
          source: source,
          status: ::Rack::Utils::SYMBOL_TO_STATUS_CODE[status].to_s
        }.compact], status: status)
      end

      def render_errors(errors, status: :bad_request)
        data = {
          errors: errors
        }
        render json: ::MultiJson.dump(data), status: status
      end

    end
  end
end