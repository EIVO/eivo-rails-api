# frozen_string_literal: true

module EIVO
  module Concerns
    module Exception
      extend ::ActiveSupport::Concern

      included do
        before_action :set_exception_context
      end

      def set_exception_context
        ::Raven.extra_context(
          params: params.to_unsafe_h,
          url: request.url,
          request_id: request.request_id
        )
      end
    end
  end
end
