require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::Workflow do
  let(:instance) { described_class.new }

  describe '::path' do
    subject { described_class.path }

    it 'returns the path' do
      expect(subject).to eq "checklists"
    end
  end

  describe '.update' do
    subject { instance.update }

    it 'calls create' do
      expect(instance).to receive(:create)
      subject
    end
  end

  describe '.steps' do
    subject { instance.steps }

    before :each do
      instance.instance_variable_set(:@steps, starting_steps)
    end

    context '@steps is already set' do
      let(:starting_steps) { random }

      it 'returns the steps' do
        expect(subject).to eq starting_steps
      end
    end

    context '@steps is not set' do
      let(:starting_steps) { nil }

      before :each do
        allow(instance).to receive(:id).and_return(id)
      end

      context 'id is set' do
        let(:id) { random }

        it 'calls get and sets the steps to the result' do
          result = Object.new
          steps = random
          expect(described_class).to receive(:get).with(id).and_return(result)
          expect(result).to receive(:steps).and_return(steps)
          expect(subject).to eq steps
        end
      end

      context 'id is not set' do
        let(:id) { nil }

        it 'sets steps to an empty array' do
          expect(subject).to eq []
        end
      end
    end
  end

  describe '.steps=' do
    subject { instance.steps = steps }

    context 'steps is not an array' do
      let(:steps) { Object.new }
      let(:step_object) { Object.new }

      it 'creates a step object from each item' do
        expect(Manifestly::Entity::WorkflowStep).to receive(:new).with(instance, steps).and_return(step_object)
        subject
        expect(instance.steps).to eq [step_object]
      end
    end

    context 'steps is an array' do
      let(:steps) { [Object.new] }
      let(:step_object) { Object.new }

      it 'creates a step object from each item' do
        expect(Manifestly::Entity::WorkflowStep).to receive(:new).with(instance, steps.first).and_return(step_object)
        subject
        expect(instance.steps).to eq [step_object]
      end
    end
  end

  describe '.tag_list' do
    subject { instance.tag_list = tag_list }

    context 'tag_list is not an array' do
      let(:tag_list) { Object.new }
      let(:tag_list_object) { Object.new }

      it 'sets attribute to the uppercase' do
        expect(tag_list).to receive(:upcase).and_return(tag_list_object)
        subject
        expect(instance.tag_list).to eq [tag_list_object]
      end
    end

    context 'tag_list is an array' do
      let(:tag_list) { [Object.new] }
      let(:tag_list_object) { Object.new }

      it 'sets attribute to the uppercase' do
        expect(tag_list.first).to receive(:upcase).and_return(tag_list_object)
        subject
        expect(instance.tag_list).to eq [tag_list_object]
      end
    end
  end
end
