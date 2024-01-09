require_relative 'endpoint'

module Manifestly
  module Entity
    class ChecklistRun < Endpoint
      attr_accessor :id, :account_id, :archive_url, :checklist_id, :checklist_title, :completed_at, :description, :detailed_title, :external_id,
                    :late_at, :percent_completed, :started_at, :state, :summary, :tag_list, :title, :version, :hide_steps_from_external,
                    :only_assigned_can_complete, :origin
      attr_reader :users

      def self.endpoint_target
        :runs
      end

      def users=(values)
        @users = Array(values).map do |it|
          next it if it.is_a?(Integer)
          next it[:id] if it.is_a?(Hash) && it[:id]

          raise "invalid user value #{it}"
        end
      end

      def steps
        return @steps if @steps

        @steps = Manifestly::Entity::ChecklistRunStep.list(self) if id
        @steps ||= []
      end
    end
  end
end
