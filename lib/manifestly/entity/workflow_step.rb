require_relative 'endpoint'

module Manifestly
  module Entity
    class WorkflowStep < ChildEndpoint
      attr_accessor :id, :checklist_id, :position, :title, :description, :description_with_links, :created_at, :updated_at, :active, :original_id,
                    :late_at_offset, :late_at_offset_units, :late_at_basis, :parent_step_id, :assignee_id, :assignee_type,
                    :late_at_basis_step_data_setting_id, :step_data_setting
      attr_reader :header_step

      invalid_method(:create)
      invalid_class_method(:get)
      invalid_method(:update)
      invalid_method(:save)
      invalid_method(:delete)

      def self.parent_class
        Workflow
      end

      def self.endpoint_target
        :steps
      end

      def content_objects
        return @content_objects if @content_objects

        @content_objects = Manifestly::Entity::WorkflowStepContentObject.list(self) if id
        @content_objects ||= []
      end

      def content_objects=(values)
        @content_objects = Array(values).map { |it| WorkflowStepContentObject.new(self, it) }
      end

      # Header step needs to always be a boolean (even if not set)
      def header_step # rubocop:disable Lint/DuplicateMethods
        @header_step || false
      end

      # Always convert to a boolean
      def header_step=(value)
        @header_step = (value.to_s == 'true')
      end
    end
  end
end
