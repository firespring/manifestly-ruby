require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::Workflow do
  let(:instance) { nil }

  before :all do
    WebMock.allow_net_connect!
  end

  after :all do
    WebMock.enable!
  end

  after :each do
    instance&.delete rescue nil
  end

  describe '.create' do
    subject { instance.create }

    let(:instance) { create(:workflow, title: title) }
    let(:title) { random }

    it 'sets all of the fields' do
      subject
      expect(instance.id).to be > 1
      expect(instance.title).to eq title
    end

    context 'with steps' do
      let(:instance) { create(:workflow, title: title, steps: [{title: step_title}]) }
      let(:step_title) { random }

      it 'creates the steps' do
        subject
        expect(instance.steps.first.title).to eq step_title

        # Get a clean object just to make sure
        remote_instance = described_class.get(instance.id)
        expect(remote_instance.steps.first.title).to eq step_title
      end
    end

    context 'with invalid keys' do
      let(:instance) { create(:workflow, invalid_key => title) }
      let(:invalid_key) { random }

      it 'raises error' do
        expect { subject }.to raise_error(/invalid.*keys were found.*#{invalid_key}/)
      end
    end
  end

  describe '.list' do
    subject { described_class.list }

    let(:instance) { create(:workflow) }

    before :each do
      instance.create
    end

    it 'returns an array of workflows' do
      expect(subject).to be_a Array
      subject.each { |it| expect(it).to be_a described_class }
    end
  end

  describe '.get' do
    subject { described_class.get(instance.id) }

    let(:instance) { create(:workflow) }

    before :each do
      instance.create
    end

    it 'all of the fields match what is in manifestly' do
      instance.attributes.each { |attr| expect(subject.send(attr)).to eq(instance.send(attr)) }
    end
  end

  describe '.update' do
    subject { instance.update }

    let(:instance) { create(:workflow) }

    before :each do
      instance.create
    end

    it 'updates the field' do
      new_title = random
      instance.title = new_title
      subject
      expect(instance.title).to eq new_title
    end

    it 'updates the field in manifestly' do
      new_title = random
      instance.title = new_title
      subject
      manifestly_data = described_class.get(instance.id)
      expect(instance.title).to eq(manifestly_data.title)
    end
  end

  describe '.delete' do
    subject { instance.delete }

    let(:instance) { create(:workflow) }

    before :each do
      instance.create
    end

    it 'deletes the instance' do
      expect { described_class.get(instance.id) }.to_not raise_error
      subject
      expect { described_class.get(instance.id) }.to raise_error(Faraday::Error::ResourceNotFound)
    end
  end
end
