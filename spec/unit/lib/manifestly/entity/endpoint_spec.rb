require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::Endpoint do
  let(:instance) { described_class.new }

  describe '.path' do
    subject { instance.path }

    it 'calls class method' do
      expect(described_class).to receive(:path)
      subject
    end
  end

  describe '::path' do
    subject { described_class.path }

    it 'raises error' do
      expect { subject }.to raise_error(/must.*override/i)
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
    let(:path) { "#{random}s" }
    let(:hash_data) { Object.new }
    let(:json_entity) { random }
    let(:response) { {body: {path.chomp('s').to_sym => json_entity}.to_json} }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(instance).to receive(:path).and_return(path)
      allow(instance).to receive(:to_h).and_return(hash_data)
    end

    it 'calls post on the client' do
      expect(client).to receive(:post).with(path, params: hash_data).and_return(response)
      expect(instance).to receive(:attributes=).with(json_entity)
      expect(subject).to eq instance
    end
  end

  describe '::list' do
    subject { described_class.list(params) }
    let(:params) { {} }
    let(:client) { Object.new }
    let(:path) { "#{random}s" }
    let(:json_entities) { [random] }
    let(:response) { {body: {path.to_sym => json_entities}.to_json} }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:path).and_return(path)
    end

    it 'calls get on the client' do
      expect(client).to receive(:get).with(path, params: params).and_return(response)
      expect(described_class).to receive(:new).with(json_entities.first).and_return(instance)
      expect(subject).to eq [instance]
    end
  end

  describe '::get' do
    subject { described_class.get(id) }
    let(:id) { random }
    let(:client) { Object.new }
    let(:path) { "#{random}s" }
    let(:json_entity) { random }
    let(:response) { {body: {path.chomp('s').to_sym => json_entity}.to_json} }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(described_class).to receive(:path).and_return(path)
    end

    it 'calls get on the client' do
      expect(client).to receive(:get).with("#{path}/#{id}").and_return(response)
      expect(described_class).to receive(:new).with(json_entity).and_return(instance)
      expect(subject).to eq instance
    end
  end

  describe '.update' do
    subject { instance.update }
    let(:id) { random }
    let(:client) { Object.new }
    let(:path) { "#{random}s" }
    let(:hash_data) { Object.new }
    let(:json_entity) { random }
    let(:response) { {body: {path.chomp('s').to_sym => json_entity}.to_json} }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(instance).to receive(:path).and_return(path)
      allow(instance).to receive(:to_h).and_return(hash_data)
      allow(instance).to receive(:id).and_return(id)
    end

    it 'calls post on the client' do
      expect(client).to receive(:post).with("#{path}/#{id}", params: hash_data).and_return(response)
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
    let(:path) { random }
    let(:external_id) { random }

    before :each do
      allow(instance).to receive(:client).and_return(client)
      allow(instance).to receive(:path).and_return(path)
      allow(instance).to receive(:external_id).and_return(external_id)
    end

    it 'calls delete on client' do
      expect(client).to receive(:delete).with(path, params: {external_id: external_id})
      expect(subject).to be_nil
    end
  end
end
