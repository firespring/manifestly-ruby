require_relative 'base'
require 'json'

module Manifestly
  module Entity
    class Endpoint < Base
      @client = nil

      def self.endpoint_target
        raise 'Must specify endpoint_target'
      end

      def endpoint_target
        self.class.endpoint_target
      end

      def self.singular_endpoint_target
        endpoint_target.to_s.chomp('s').to_sym
      end

      def singular_endpoint_target
        self.class.singular_endpoint_target
      end

      def location
        self.class.location
      end

      def self.location
        endpoint_target
      end

      def client
        self.class.client
      end

      def self.client
        @client ||= Manifestly::Client.new
      end

      def create(path: location)
        response = client.post(path, params: to_h)
        json_entity = JSON.parse(response[:body], symbolize_names: true)[singular_endpoint_target]
        self.attributes = json_entity
        self
      end

      def self.list(path: location, **params)
        response = client.get(path, params: params)
        json_entities = JSON.parse(response[:body], symbolize_names: true)[endpoint_target]
        json_entities.map { |it| new(it) }
      end

      def self.get(id, path: location)
        response = client.get("#{path}/#{id}")
        json_entity = JSON.parse(response[:body], symbolize_names: true)[singular_endpoint_target.to_sym]
        new(json_entity)
      end

      def update(path: location)
        client.post("#{path}/#{id}", params: to_h)
        self
      end

      def save
        if id
          update
        else
          create
        end
      end

      def delete(path: location)
        client.delete(path, params: {external_id: external_id})
        nil
      end
    end

    class ChildEndpoint < Endpoint
      def parent_class
        self.class.parent_class
      end

      def self.parent_class
        raise 'Must specify parent_class'
      end

      def initialize(parent, data = {})
        raise "invalid #{parent_class}" unless parent.is_a?(parent_class)

        @parent = parent
        super(data)
      end

      def location
        self.class.location(@parent)
      end

      def self.location(parent)
        "#{parent.location}/#{parent.id}/#{endpoint_target}"
      end

      def self.list(parent, **params)
        response = client.get(location(parent), params: params)
        json_entities = JSON.parse(response[:body], symbolize_names: true)[endpoint_target]
        json_entities.map { |it| new(parent, it) }
      end

      def self.get(id, parent)
        response = client.get("#{location(parent)}/#{id}")
        json_entity = JSON.parse(response[:body], symbolize_names: true)[singular_endpoint_target.to_sym]
        new(parent, json_entity)
      end

      def update(path: location)
        client.put("#{path}/#{id}", params: to_h)
        self
      end

      def delete(path: location)
        client.delete("#{path}/#{id}")
        nil
      end
    end
  end
end
