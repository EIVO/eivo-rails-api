# frozen_string_literal: true

module EIVO
  module Concerns
    module Resources
      extend ::ActiveSupport::Concern

      included do
        before_action :set_default_serializer_options
      end

      def index
        @objects ||= collection_index

        unless ::ActiveModel::Type::Boolean.new.cast(params[:pagination]) == false
          limit = 50
          if params[:limit]
            limit = [[params[:limit].to_i, 1].max, 500].min
          end

          @objects = @objects.page(params[:page]).per(limit)
          @serializer_options.merge!(pagination_options(@objects))
        end

        render_success serializer.new(@objects, @serializer_options)
      end

      def show
        @object ||= collection.find(params[:id])
        render_success serializer.new(@object, @serializer_options)
      end

      def create
        @object ||= collection.new(object_params_create)
        if @object.save
          render_success serializer.new(@object, @serializer_options)
        else
          render_model_errors @object.errors
        end
      end

      def update
        @object ||= collection.find(params[:id])
        if @object.update(object_params_update)
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
