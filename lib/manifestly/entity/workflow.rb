require_relative 'endpoint'

module Manifestly
  module Entity
    class Workflow < Endpoint
      attr_accessor :id, :account_id, :business_days, :channel, :description, :expected_duration, :expected_duration_units, :external_id,
                    :hide_steps_from_external, :title
      attr_reader :steps, :tag_list

      def self.endpoint_target
        :checklists
      end

      # Workflows use an 'upsert' methodology so the create and update routes are shared.
      # Lookups are done via the external_id you pass in
      def update
        create
      end

      def steps # rubocop:disable Lint/DuplicateMethods
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
