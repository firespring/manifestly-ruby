require 'entity/base'
require 'json'

module Manifestly
  module Entity
    class Endpoint < Base
      @client = nil

      def path
        self.class.path
      end

      def self.path
        raise 'Must override method'
      end

      def client
        self.class.client
      end

      def self.client
        @client ||= Manifestly::Client.new
      end

      def create
        response = client.post(path, params: to_h)
        json_entity = JSON.parse(response[:body], symbolize_names: true)[path.chomp('s').to_sym]
        self.attributes = json_entity
        self
      end

      def self.list(**params)
        response = client.get(path, params: params)
        json_entities = JSON.parse(response[:body], symbolize_names: true)[path.to_sym]
        json_entities.map { |it| new(it) }
      end

      def self.get(id)
        response = client.get("#{path}/#{id}")
        json_entity = JSON.parse(response[:body], symbolize_names: true)[path.chomp('s').to_sym]
        new(json_entity)
      end

      def update
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

      def delete
        client.delete(path, params: {external_id: external_id})
        nil
      end
    end
  end
end
