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
