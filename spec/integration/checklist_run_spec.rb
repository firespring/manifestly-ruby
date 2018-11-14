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

    let(:instance) { build(:checklist_run, checklist_id: workflow.id, title: title, users: users) }
    let(:title) { random }
    let(:workflow) { build(:workflow, title: title, steps: [{title: step_title}]).create }
    let(:step_title) { random }
    let(:users) { [Manifestly::Entity::User.list.first.id] }

    it 'sets all of the fields' do
      subject
      expect(instance.id).to be > 1
      expect(instance.title).to eq title
      expect(instance.users).to eq users
      expect(instance.steps.first.title).to eq step_title
    end
  end

  describe '.list' do
    subject { Manifestly::Entity::ChecklistRun.list(filter) }

    let(:filter) { {title: instance.title} }
    let(:instance) { build(:checklist_run, checklist_id: workflow.id, title: title, users: users).create }
    let(:title) { random }
    let(:workflow) { build(:workflow, title: title, steps: [{title: step_title}]).create }
    let(:step_title) { random }
    let(:users) { [Manifestly::Entity::User.list.first.id] }

    it 'finds the checklist run' do
      expect(subject.first.id).to be > 1
      expect(subject.first.title).to eq title
      expect(subject.first.users).to eq users
      expect(subject.first.steps.first.title).to eq step_title
    end
  end
end
