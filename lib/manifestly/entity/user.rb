require_relative 'endpoint'

module Manifestly
  module Entity
    class User < Endpoint
      attr_accessor :id
      attr_accessor :avatar_url
      attr_accessor :email
      attr_accessor :name
      attr_accessor :simple_display_name
      attr_accessor :username
      attr_accessor :membership_id
      attr_accessor :role

      invalid_method(:create)
      invalid_class_method(:get)
      invalid_method(:update)
      invalid_method(:save)
      invalid_method(:delete)

      def self.path
        'users'
      end
    end
  end
end
