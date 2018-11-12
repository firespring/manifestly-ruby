require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::WorkflowStep do
  let(:instance) { described_class.new(workflow, data) }
  let(:workflow) { Object.new }
  let(:data) { {} }

  before :each do
    allow(workflow).to receive(:is_a?).with(Manifestly::Entity::Workflow).and_return(true)
  end

  describe '.initialize' do
    subject { instance }
    let(:data) { {title: title} }
    let(:title) { random }

    it 'sets the attributes' do
      expect(subject.title).to eq title
    end

    context 'invalid parent class' do
      it 'raises error' do
        expect(workflow).to receive(:is_a?).with(Manifestly::Entity::Workflow).and_return(false)
        expect { subject }.to raise_error(/invalid.*workflow/i)
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
