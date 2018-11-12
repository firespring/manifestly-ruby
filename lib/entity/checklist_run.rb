require 'entity/endpoint'

module Manifestly
  module Entity
    class ChecklistRun < Endpoint
      attr_accessor :id
      attr_accessor :account_id
      attr_accessor :archive_url
      attr_accessor :checklist_id
      attr_accessor :checklist_title
      attr_accessor :completed_at
      attr_accessor :description
      attr_accessor :detailed_title
      attr_accessor :external_id
      attr_accessor :late_at
      attr_accessor :percent_completed
      attr_accessor :started_at
      attr_accessor :state
      attr_accessor :summary
      attr_accessor :tag_list
      attr_accessor :title
      attr_accessor :version
      attr_accessor :hide_steps_from_external
      attr_accessor :only_assigned_can_complete
      attr_reader :users
      attr_accessor :origin

      def self.path
        'runs'
      end

      def users=(values)
        @users = Array(values).map do |it|
          next it if it.is_a?(Integer)
          next it[:id] if it.is_a?(Hash) && it[:id]

          raise "invalid user value #{it}"
        end
      end

      def steps
        @steps ||= Manifestly::Entity::ChecklistStep.list(self)
      end
    end
  end
end
