require 'entity/endpoint'
require 'date'

module Manifestly
  module Entity
    class ChecklistStep < Endpoint
      attr_accessor :id
      attr_accessor :assignee_avatar_url
      attr_accessor :assignee_id
      attr_accessor :assignee_name
      attr_accessor :assignee_user_id
      attr_accessor :assignee_simple_display_name
      attr_accessor :completed_at
      attr_accessor :comments
      attr_accessor :data
      attr_accessor :description_with_links
      attr_accessor :run_detailed_title
      attr_reader :header_step
      attr_accessor :late_at
      attr_accessor :position
      attr_accessor :run_id
      attr_accessor :skipped
      attr_accessor :title
      attr_accessor :user_id
      attr_accessor :user
      attr_accessor :picture
      attr_accessor :run_step_data_setting

      invalid_method(:create)
      invalid_class_method(:get)
      invalid_method(:update)
      invalid_method(:save)
      invalid_method(:delete)

      def initialize(run, data = {})
        raise 'invalid checklist run' unless run.is_a?(ChecklistRun)

        @parent = run
        super(data)
      end

      # Header step needs to always be a boolean (even if not set)
      def header_step # rubocop:disable DuplicateMethods
        @header_step || false
      end

      # Always convert to a boolean
      def header_step=(value)
        @header_step = (value.to_s == 'true')
      end

      def self.path
        'run_steps'
      end

      def self.list(run)
        response = client.get("#{run.path}/#{run.id}/#{path}")
        json_entities = JSON.parse(response[:body], symbolize_names: true)[path.to_sym]
        json_entities.map { |it| new(run, it) }
      end

      def complete
        puts "#{@parent.path}/#{@parent.id}/#{path}/#{id}/complete"
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/complete")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def uncomplete
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/uncomplete")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def skip
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/skip")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def unskip
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/unskip")
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def add_data(data)
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/data", params: {data: data})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def add_picture(base_64_encoded_picture_data)
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/picture", params: {picture: base_64_encoded_picture_data})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def add_comment(comment)
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/comments", params: {comment: comment})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end

      def assign(user_id)
        puts "CALLING [ #{@parent.path}/#{@parent.id}/#{path}/#{id}/assign ] with {assignee_user_id: #{user_id}}"
        client.post("#{@parent.path}/#{@parent.id}/#{path}/#{id}/assign", params: {assignee_user_id: user_id})
        @parent.instance_variable_set(:@steps, nil)
        nil
      end
    end
  end
end
