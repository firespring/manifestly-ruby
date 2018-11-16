require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::Endpoint do
  let(:instance) { described_class.new }

  describe '.location' do
    subject { instance.location }

    it 'calls class method' do
      expect(described_class).to receive(:location)
      subject
    end
  end

  describe '::location' do
    subject { described_class.location }

    it 'raises error' do
      expect { subject }.to raise_error(/must.*specify/i)
    end
  end

  describe '.client' do
    subject { instance.client }

    it 'calls class method' do
      expect(described_class).to receive(:client)
      subject
    end
  end

  describe '::client' do
    subject { described_class.client }
    let(:client) { Object.new }

    it 'raises error' do
      described_class.instance_variable_set(:@client, nil)
      expect(Manifestly::Client).to receive(:new).and_return(client)
      subject
      expect(described_class.instance_variable_get(:@client)).to eq client
    end
  end

  describe '.create' do
    subject { instance.create }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:hash_data) { Object.new }
    let(:json_entity) { random }
    let(:response) { {body: {instance.singular_endpoint_target => json_entity}.to_json} }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
      allow(instance).to receive(:to_h).and_return(hash_data)
    end

    it 'calls post on the client' do
      expect(client).to receive(:post).with(instance.endpoint_target, params: hash_data).and_return(response)
      expect(instance).to receive(:attributes=).with(json_entity)
      expect(subject).to eq instance
    end
  end

  describe '::list' do
    subject { described_class.list(params) }
    let(:params) { {} }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:json_entities) { [random] }
    let(:response) { {body: {described_class.endpoint_target => json_entities}.to_json} }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
    end

    it 'calls get on the client' do
      expect(client).to receive(:get).with(described_class.endpoint_target, params: params).and_return(response)
      expect(described_class).to receive(:new).with(json_entities.first).and_return(instance)
      expect(subject).to eq [instance]
    end
  end

  describe '::get' do
    subject { described_class.get(id) }
    let(:id) { random }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:json_entity) { random }
    let(:response) { {body: {described_class.singular_endpoint_target => json_entity}.to_json} }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
    end

    it 'calls get on the client' do
      expect(client).to receive(:get).with("#{endpoint_target}/#{id}").and_return(response)
      expect(described_class).to receive(:new).with(json_entity).and_return(instance)
      expect(subject).to eq instance
    end
  end

  describe '.update' do
    subject { instance.update }
    let(:id) { random }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:hash_data) { Object.new }
    let(:json_entity) { random }
    let(:response) { {body: {instance.endpoint_target => json_entity}.to_json} }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
      allow(instance).to receive(:to_h).and_return(hash_data)
      allow(instance).to receive(:id).and_return(id)
    end

    it 'calls post on the client' do
      expect(client).to receive(:post).with("#{endpoint_target}/#{id}", params: hash_data).and_return(response)
      expect(subject).to eq instance
    end
  end

  describe '.save' do
    subject { instance.save }

    before :each do
      allow(instance).to receive(:id).and_return(id)
    end

    context 'when id is set' do
      let(:id) { random }

      it 'calls update' do
        expect(instance).to receive(:update)
        subject
      end
    end

    context 'when id is unset' do
      let(:id) { nil }

      it 'calls create' do
        expect(instance).to receive(:create)
        subject
      end
    end
  end

  describe '.delete' do
    subject { instance.delete }
    let(:client) { Object.new }
    let(:endpoint_target) { random }
    let(:external_id) { random }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
      allow(instance).to receive(:external_id).and_return(external_id)
    end

    it 'calls delete on client' do
      expect(client).to receive(:delete).with(instance.endpoint_target, params: {external_id: external_id})
      expect(subject).to be_nil
    end
  end
end

describe Manifestly::Entity::ChildEndpoint do
  let(:instance) { described_class.new(parent, data) }
  let(:parent) { OpenStruct.new(id: id, location: location) }
  let(:id) { random }
  let(:location) { random }
  let(:data) { {} }
  let(:endpoint_target) { random }

  before :each do
    allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
    allow(described_class).to receive(:parent_class).and_return(parent)
    allow(parent).to receive(:is_a?).and_return(true)
  end

  describe '.parent_class' do
    subject { instance.parent_class }

    it 'calls the class method' do
      expect(described_class).to receive(:parent_class).and_return(parent)
      expect(subject).to eq parent
    end
  end

  describe '::parent_class' do
    subject { described_class.parent_class }

    it 'raises error' do
      expect(described_class).to receive(:parent_class).and_call_original
      expect { subject }.to raise_error(/must.*specify.*parent_class/i)
    end
  end

  describe '.initialize' do
    subject { instance }

    it 'sets the parent' do
      expect(subject.instance_variable_get(:@parent)).to eq parent
    end

    context 'invalid parent class' do
      it 'raises error' do
        expect(parent).to receive(:is_a?).and_return(false)
        expect { subject }.to raise_error(/invalid.*#{parent}/i)
      end
    end
  end

  describe '.location' do
    subject { instance.location }

    it 'calls the class method' do
      expect(described_class).to receive(:location).with(parent)
      subject
    end
  end

  describe '::location' do
    subject { described_class.location(parent) }

    it 'returns a string' do
      expect(subject).to eq "#{parent.location}/#{parent.id}/#{endpoint_target}"
    end
  end

  describe '::list' do
    subject { described_class.list(parent, params) }
    let(:params) { {} }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:json_entities) { [random] }
    let(:response) { {body: {described_class.endpoint_target => json_entities}.to_json} }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
    end

    it 'calls get on the client' do
      expect(client).to receive(:get).with(described_class.location(parent), params: params).and_return(response)
      expect(described_class).to receive(:new).with(parent, json_entities.first).and_return(instance)
      expect(subject).to eq [instance]
    end
  end

  describe '::get' do
    subject { described_class.get(id, parent) }
    let(:id) { random }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:json_entity) { random }
    let(:response) { {body: {described_class.singular_endpoint_target => json_entity}.to_json} }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
    end

    it 'calls get on the client' do
      expect(client).to receive(:get).with("#{described_class.location(parent)}/#{id}").and_return(response)
      expect(described_class).to receive(:new).with(parent, json_entity).and_return(instance)
      expect(subject).to eq instance
    end
  end

  describe '.update' do
    subject { instance.update }
    let(:id) { random }
    let(:client) { Object.new }
    let(:endpoint_target) { "#{random}s".to_sym }
    let(:hash_data) { Object.new }
    let(:json_entity) { random }
    let(:response) { {body: {instance.endpoint_target => json_entity}.to_json} }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
      allow(instance).to receive(:to_h).and_return(hash_data)
      allow(instance).to receive(:id).and_return(id)
    end

    it 'calls post on the client' do
      expect(client).to receive(:put).with("#{instance.location}/#{id}", params: hash_data).and_return(response)
      expect(subject).to eq instance
    end
  end

  describe '.delete' do
    subject { instance.delete }
    let(:client) { Object.new }
    let(:endpoint_target) { random }
    let(:id) { random }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(described_class).to receive(:endpoint_target).and_return(endpoint_target)
      allow(instance).to receive(:id).and_return(id)
    end

    it 'calls delete on client' do
      expect(client).to receive(:delete).with("#{instance.location}/#{instance.id}")
      expect(subject).to be_nil
    end
  end
end


