require_relative 'endpoint'

module Manifestly
  module Entity
    class Workflow < Endpoint
      attr_accessor :id
      attr_accessor :account_id
      attr_accessor :business_days
      attr_accessor :description
      attr_accessor :expected_duration
      attr_accessor :expected_duration_units
      attr_accessor :external_id
      attr_accessor :hide_steps_from_external
      attr_reader :steps
      attr_reader :tag_list
      attr_accessor :title

      def self.endpoint_target
        :checklists
      end

      # Workflows use an 'upsert' methodology so the create and update routes are shared.
      # Lookups are done via the external_id you pass in
      def update
        create
      end

      def steps # rubocop:disable DuplicateMethods
        return @steps if @steps

        @steps = Manifestly::Entity::WorkflowStep.list(self) if id
        @steps ||= []
      end

      def steps=(values)
        @steps = Array(values).map { |it| WorkflowStep.new(self, it) }
      end

      def tag_list=(values)
        @tag_list = Array(values).map(&:upcase)
      end
    end
  end
end
