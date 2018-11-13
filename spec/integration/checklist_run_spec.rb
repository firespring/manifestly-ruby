require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::ChecklistRun do
  let(:instance) { nil }
  let(:workflow) { nil }

  before :all do
    WebMock.allow_net_connect!
  end

  after :all do
    WebMock.enable!
  end

  after :each do
    instance&.delete rescue nil
    workflow&.delete rescue nil
  end

  describe '.create' do
    subject { instance.create }

    let(:instance) { create(:checklist_run, workflow: workflow, title: title) }
    let(:title) { random }
    let(:workflow) { create(:workflow, title: title, steps: [{title: step_title}]).create }
    let(:step_title) { random }

    it 'sets all of the fields' do
      subject
      expect(instance.id).to be > 1
      expect(instance.title).to eq title
      expect(instance.steps.first.title).to eq step_title
    end
  end

  describe '.'
end
