require_relative 'endpoint'
require 'date'

module Manifestly
  module Entity
    class ChecklistRunStep < ChildEndpoint
      attr_accessor :id, :assignee_avatar_url, :assignee_id, :assignee_name, :assignee_user_id, :assignee_simple_display_name, :completed_at,
                    :comments, :data, :description_with_links, :run_detailed_title, :late_at, :position, :run_id, :skipped, :title, :user_id,
                    :user, :picture, :run_step_data_setting
      attr_reader :header_step

      invalid_method(:create)
      invalid_class_method(:get)
      invalid_method(:update)
      invalid_method(:save)
      invalid_method(:delete)

      def self.parent_class
        ChecklistRun
      end

      def self.endpoint_target
        :run_steps
      end

      # Header step needs to always be a boolean (even if not set)
      def header_step # rubocop:disable Lint/DuplicateMethods
        @header_step || false
      end

      # Always convert to a boolean
      def header_step=(value)
        @header_step = (value.to_s == 'true')
      end

      def complete
        client.post("#{location}/#{id}/complete")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def uncomplete
        client.post("#{location}/#{id}/uncomplete")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def skip
        client.post("#{location}/#{id}/skip")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def unskip
        client.post("#{location}/#{id}/unskip")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def add_data(data)
        client.post("#{location}/#{id}/data", params: {data:})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def add_picture(base_64_encoded_picture_data)
        client.post("#{location}/#{id}/picture", params: {picture: base_64_encoded_picture_data})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def add_comment(comment)
        client.post("#{location}/#{id}/comments", params: {comment:})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def assign(user_id)
        client.post("#{location}/#{id}/assign", params: {assignee_user_id: user_id})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end
    end
  end
end
