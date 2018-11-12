require 'entity/endpoint'

module Manifestly
  module Entity
    class WorkflowStep < Base
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

      def initialize(workflow, data = {})
        raise 'invalid workflow' unless workflow.is_a?(Workflow)

        @parent = workflow
        super(data)
      end

      # Always convert to a boolean
      def header_step=(value)
        @header_step = (value.to_s == 'true')
      end

      # Header step needs to always be a boolean (even if not set)
      def header_step
        @header_step || false
      end
    end
  end
end
