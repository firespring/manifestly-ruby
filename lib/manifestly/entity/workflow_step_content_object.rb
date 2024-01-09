require_relative 'endpoint'

module Manifestly
  module Entity
    class WorkflowStepContentObject < ChildEndpoint
      attr_accessor :id, :caption, :content, :content_type, :position

      def self.parent_class
        WorkflowStep
      end

      def self.endpoint_target
        :content_objects
      end
    end
  end
end
