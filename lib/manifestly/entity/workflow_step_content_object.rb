require_relative 'endpoint'

module Manifestly
  module Entity
    class WorkflowStepContentObject < ChildEndpoint
      attr_accessor :id
      attr_accessor :caption
      attr_accessor :content
      attr_accessor :content_type
      attr_accessor :position

      def self.parent_class
        WorkflowStep
      end

      def self.endpoint_target
        :content_objects
      end
    end
  end
end
