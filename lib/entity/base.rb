module Manifestly
  module Entity
    class Base
      @attributes = nil

      def initialize(data = {})
        invalids = data.keys - attributes
        raise "The following invalid #{self.class} keys were found: #{invalids}" unless invalids.empty?

        self.attributes = data
      end

      def attributes
        self.class.attributes
      end

      def self.attributes
        @attributes ||= []
      end

      def attributes=(attrs)
        attrs.each { |k, v| send(:"#{k}=", v) }
      end

      def self.attr_accessor(*attrs)
        attrs.each { |attr| attributes << attr }
        super
      end

      def self.attr_reader(*attrs)
        attrs.each { |attr| attributes << attr }
        super
      end

      def self.invalid_method(*names)
        names&.each { |name| define_method(name) { |*_, **_| raise 'invalid method' } }
      end

      def self.invalid_class_method(*names)
        names&.each { |name| define_method(name) { |*_, **_| raise 'invalid method' } }
      end

      def to_h
        {}.tap do |hsh|
          attributes.each do |attr|
            value = send(attr)
            if value.is_a?(Array)
              value = value.map do |it|
                next it.to_h if it.is_a?(Manifestly::Entity::Base)

                it
              end
            end
            hsh[attr] = value
          end
        end
      end
    end
  end
end
