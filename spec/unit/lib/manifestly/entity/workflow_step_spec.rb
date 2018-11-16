require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::WorkflowStep do
  let(:instance) { described_class.new(workflow, data) }
  let(:workflow) { Object.new }
  let(:data) { {} }

  before :each do
    allow(workflow).to receive(:is_a?).with(Manifestly::Entity::Workflow).and_return(true)
  end

  describe '::parent_class' do
    subject { described_class.parent_class }

    it 'returns Workflow' do
      expect(subject).to eq Manifestly::Entity::Workflow
    end
  end

  describe '::endoint_target' do
    subject { described_class.endpoint_target }

    it 'returns :steps' do
      expect(subject).to eq :steps
    end
  end

  describe '.content_objects' do
    subject { instance.content_objects }

    before :each do
      instance.instance_variable_set(:@content_objects, starting_content_objects)
    end

    context '@content_objects is already set' do
      let(:starting_content_objects) { random }

      it 'returns the content_objects' do
        expect(subject).to eq starting_content_objects
      end
    end

    context '@content_objects is not set' do
      let(:starting_content_objects) { nil }

      before :each do
        allow(instance).to receive(:id).and_return(id)
      end

      context 'id is set' do
        let(:id) { random }

        it 'calls get and sets the content_objects to the result' do
          content_objects = random
          expect(Manifestly::Entity::WorkflowStepContentObject).to receive(:list).with(instance).and_return(content_objects)
          expect(subject).to eq content_objects
        end
      end

      context 'id is not set' do
        let(:id) { nil }

        it 'sets content_objects to an empty array' do
          expect(subject).to eq []
        end
      end
    end
  end

  describe '.content_objects=' do
    subject { instance.content_objects = content_objects }

    context 'content_objects is not an array' do
      let(:content_objects) { Object.new }
      let(:content_object) { Object.new }

      it 'creates a content object from each item' do
        expect(Manifestly::Entity::WorkflowStepContentObject).to receive(:new).with(instance, content_objects).and_return(content_object)
        subject
        expect(instance.content_objects).to eq [content_object]
      end
    end

    context 'content_objects is an array' do
      let(:content_objects) { [Object.new] }
      let(:content_object) { Object.new }

      it 'creates a content object from each item' do
        expect(Manifestly::Entity::WorkflowStepContentObject).to receive(:new).with(instance, content_objects.first).and_return(content_object)
        subject
        expect(instance.content_objects).to eq [content_object]
      end
    end
  end

  describe 'header_step' do
    subject { instance.header_step }

    let(:header_step) { random }

    before :each do
      instance.instance_variable_set(:@header_step, header_step)
    end

    it 'returns the header step' do
      expect(subject).to eq header_step
    end

    context 'when header step is nil' do
      let(:header_step) { nil }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '.header_step=' do
    subject { instance.header_step = header_step }

    context 'header_step is true' do
      let(:header_step) { true }

      it 'sets header step to true' do
        subject
        expect(instance.header_step).to be_truthy
      end
    end

    context 'header_step is false' do
      let(:header_step) { false }

      it 'sets header step to false' do
        subject
        expect(instance.header_step).to be_falsey
      end
    end

    context 'header_step is nil' do
      let(:header_step) { nil }

      it 'sets header step to nil' do
        subject
        expect(instance.header_step).to be_falsey
      end
    end

    context 'header_step is an object' do
      let(:header_step) { Object.new }

      it 'sets header step to false' do
        subject
        expect(instance.header_step).to be_falsey
      end
    end
  end
end
