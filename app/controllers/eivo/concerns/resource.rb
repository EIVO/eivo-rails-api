# frozen_string_literal: true

module EIVO
  module Concerns
    module Resource
      extend ::ActiveSupport::Concern

      included do
        before_action :set_default_serializer_options
      end

      def show
        @object ||= collection
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
        @object ||= collection
        @object.assign_attributes(object_params_update)

        if @object.save
          render_success serializer.new(@object, @serializer_options)
        else
          render_model_errors @object.errors
        end
      end

      def destroy
        @object ||= collection

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
