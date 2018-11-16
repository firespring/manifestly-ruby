require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::WorkflowStepContentObject do
  describe '::parent_class' do
    subject { described_class.parent_class }

    it 'returns WorkflowStep' do
      expect(subject).to eq Manifestly::Entity::WorkflowStep
    end
  end

  describe '::endoint_target' do
    subject { described_class.endpoint_target }

    it 'returns :steps' do
      expect(subject).to eq :content_objects
    end
  end
end
