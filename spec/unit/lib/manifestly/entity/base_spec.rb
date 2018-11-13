require 'spec_helper'
require 'manifestly'

module Manifestly
  module Entity
    class Test < Manifestly::Entity::Base
      attr_reader :read
      attr_accessor :read_write

      invalid_method(:invalid_instance_method)
      invalid_class_method(:invalid_class_method)
    end
  end
end

describe Manifestly::Entity::Test do
  let(:instance) { described_class.new(data) }
  let(:data) { {} }

  describe '.initialize' do
    subject { instance }

    it 'returns an entity' do
      expect(subject).to be_a described_class
      expect(subject.attributes).to eq [:read, :read_write]
    end

    context 'when extra keys are found' do
      let(:data) { {invalid_key => random} }
      let(:invalid_key) { random }

      it 'raises error' do
        expect { subject }.to raise_error(/invalid.*keys.*#{invalid_key}/i)
      end
    end
  end

  describe '.attributes=' do
    subject { instance.attributes = attributes }
    let(:attributes) { {read_write: value} }
    let(:value) { random }

    it 'sets the attributes' do
      subject
      expect(instance.read_write).to eq value
    end
  end

  describe '::attr_reader' do
    it 'adds the methods to attributes' do
      expect(described_class.attributes).to include :read
    end

    it 'adds the getter method' do
      expect(instance).to respond_to :read
    end
  end

  describe '::attr_accessor' do
    it 'adds the methods to attributes' do
      expect(described_class.attributes).to include :read_write
    end

    it 'adds the getter method' do
      expect(instance).to respond_to :read_write
    end

    it 'adds the setter method' do
      expect(instance).to respond_to :read_write=
    end
  end

  describe '::invalid_method' do
    subject { instance.invalid_instance_method }

    it 'raises error' do
      expect { subject }.to raise_error('invalid method')
    end
  end

  describe '::invalid_class_method' do
    subject { instance.invalid_class_method }

    it 'raises error' do
      expect { subject }.to raise_error('invalid method')
    end
  end

  describe '.to_h' do
    subject { instance.to_h }
    let(:data) { {read_write: value} }
    let(:value) { random }

    it 'creates keys for all attributes' do
      expect(subject).to be_a Hash
      expect(subject[:read_write]).to eq value
    end

    context 'when value is an array of entities' do
      let(:data) { {read_write: [described_class.new(read_write: value)]} }

      it 'hashes sub objects' do
        expect(subject[:read_write].first[:read_write]).to eq value
      end
    end

    context 'when value is an array of non-entities' do
      let(:data) { {read_write: [value]} }
      let(:value) { random }

      it 'includes the arran unchanged' do
        expect(subject[:read_write].first).to eq value
      end
    end
  end
end
