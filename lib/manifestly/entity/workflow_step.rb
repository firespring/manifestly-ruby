require_relative 'endpoint'

module Manifestly
  module Entity
    class WorkflowStep < ChildEndpoint
      attr_accessor :id
      attr_accessor :checklist_id
      attr_accessor :position
      attr_accessor :title
      attr_accessor :description
      attr_accessor :description_with_links
      attr_accessor :created_at
      attr_accessor :updated_at
      attr_reader :header_step
      attr_accessor :active
      attr_accessor :original_id
      attr_accessor :late_at_offset
      attr_accessor :late_at_offset_units
      attr_accessor :late_at_basis
      attr_accessor :parent_step_id

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
      def header_step # rubocop:disable DuplicateMethods
        @header_step || false
      end

      # Always convert to a boolean
      def header_step=(value)
        @header_step = (value.to_s == 'true')
      end
    end
  end
end
