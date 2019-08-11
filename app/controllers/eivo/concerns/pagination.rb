# frozen_string_literal: true

module EIVO
  module Concerns
    module Pagination
      extend ::ActiveSupport::Concern

      def paginate(collection)
        unless ::ActiveModel::Type::Boolean.new.cast(params[:pagination]) == false
          limit = 50
          if params[:limit]
            limit = [[params[:limit].to_i, 1].max, 500].min
          end

          collection = collection.page(params[:page]).per(limit)
          @serializer_options.merge!(pagination_options(collection))
        end

        collection
      end

      def pagination_options(collection)
        options = {
          is_collection: true,
          meta: {
            total: collection.total_count,
            pages: collection.total_pages
          },
          links: {
            self: url_for(params.to_unsafe_h.merge({ page: collection.current_page })),
            first: url_for(params.to_unsafe_h.merge({ page: 1 })),
            last: url_for(params.to_unsafe_h.merge({ page: collection.total_pages })),
          }
        }

        if !collection.out_of_range? && !collection.first_page?
          options[:links][:prev] = url_for(params.to_unsafe_h.merge({ page: collection.prev_page }))
        end
        if !collection.out_of_range? && !collection.last_page?
          options[:links][:next] = url_for(params.to_unsafe_h.merge({ page: collection.next_page }))
        end

        options
      end

    end
  end
end
