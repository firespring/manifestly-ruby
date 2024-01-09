require_relative 'endpoint'

module Manifestly
  module Entity
    class User < Endpoint
      attr_accessor :id, :avatar_url, :email, :name, :simple_display_name, :username, :membership_id, :role

      invalid_method(:create)
      invalid_class_method(:get)
      invalid_method(:update)
      invalid_method(:save)
      invalid_method(:delete)

      def self.endpoint_target
        :users
      end
    end
  end
end
