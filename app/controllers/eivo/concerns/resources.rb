# frozen_string_literal: true

module EIVO
  module Concerns
    module Resources
      extend ::ActiveSupport::Concern

      include EIVO::Concerns::Pagination

      included do
        before_action :set_default_serializer_options
      end

      def index(options = {})
        @objects ||= collection_index

        @objects = paginate(@objects) unless options[:paginate] == false

        if options[:cache] && options[:cache] != false
          if options[:cache].is_a?(Hash)
            cache_options = options[:cache]
          else
            cache_options =  {}
          end            

          if stale?(@objects, public: cache_options.fetch(:public, false))
            render_success serializer.new(@objects, @serializer_options)
          end
        else
          render_success serializer.new(@objects, @serializer_options)
        end
      end

      def show
        @object ||= collection.find(params[:id])
        render_success serializer.new(@object, @serializer_options)
      end

      def create
        @object ||= collection.new
        @object.assign_attributes(object_params_create)

        if @object.save
          render_success serializer.new(@object, @serializer_options)
        else
          render_model_errors @object.errors
        end
      end

      def update
        @object ||= collection.find(params[:id])
        @object.assign_attributes(object_params_update)

        if @object.save
          render_success serializer.new(@object, @serializer_options)
        else
          render_model_errors @object.errors
        end
      end

      def destroy
        @object ||= collection.find(params[:id])

        if @object.destroy
          render_success
        else
          render_model_errors @object.errors
        end
      end

    protected
      
      def collection
        raise NotImplementedError
      end

      def collection_index
        collection
      end

      def serializer
        raise NotImplementedError
      end

      def object_params
        raise NotImplementedError
      end

      def object_params_create
        object_params
      end

      def object_params_update
        object_params
      end

      def set_default_serializer_options
        @serializer_options ||= {}
      end

    end
  end
end
