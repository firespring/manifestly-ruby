require 'spec_helper'
require 'manifestly'

describe :README do
  before :all do
    raise 'MANIFESTLY_API_KEY not set' unless ENV['MANIFESTLY_API_KEY']
    raise 'API_KEY_EMAIL' unless ENV['API_KEY_EMAIL']
  end

  before :all do
    WebMock.allow_net_connect!
  end

  after :all do
    WebMock.enable!
  end

  describe 'block1' do
    it 'returns an array' do
      require 'manifestly'
      ENV['MANIFESTLY_API_KEY'] = ENV['MANIFESTLY_API_KEY']
      workflows = Manifestly::Entity::Workflow.list

      expect(workflows).to be_a (Array)
      workflows.each { |it| expect(it).to be_a Manifestly::Entity::Workflow }
    end
  end

  describe 'block2' do
    it 'creates the workflow' do
      workflow = nil
      begin
        data = {title: 'Test Workflow', external_id: 'abc123'}
        workflow = Manifestly::Entity::Workflow.new(data).create
        workflow.create
        expect(workflow.id).to be > 1
        expect(Manifestly::Entity::Workflow.get(workflow.id)).to be_a Manifestly::Entity::Workflow

      ensure
        workflow&.delete rescue nil
      end
    end
  end

  describe 'block3' do
    it 'upserts a workflow with an external id' do
      workflow = nil
      begin
        data = {title: 'Test Workflow Upsert', external_id: 'def456'}
        workflow = Manifestly::Entity::Workflow.new(data).create
        expect(workflow.id).to be > 1
        expect(workflow.title).to eq data[:title]
        expect(Manifestly::Entity::Workflow.get(workflow.id)).to be_a Manifestly::Entity::Workflow

        workflow.title = "#{workflow.title} (updated)"
        workflow.create
        expect(workflow.title).to end_with '(updated)'
        expect(Manifestly::Entity::Workflow.get(workflow.id).title).to end_with '(updated)'

      ensure
        workflow&.delete rescue nil
      end
    end
  end

  describe 'block4' do
    it 'deletes a workflow with an external id' do
      workflow = nil
      begin
        data = {title: 'Test Workflow Delete', external_id: 'ghi789'}
        workflow = Manifestly::Entity::Workflow.new(data).create
        expect(workflow.id).to be > 1
        expect(Manifestly::Entity::Workflow.get(workflow.id)).to be_a Manifestly::Entity::Workflow

        workflow.delete
        expect { Manifestly::Entity::Workflow.get(workflow.id) }.to raise_error(Faraday::ResourceNotFound)

      ensure
        workflow&.delete rescue nil
      end
    end
  end

  describe 'block5' do
    it 'creates the workflow with steps' do
      workflow = nil
      begin
        data = {title: 'Test Workflow with steps', external_id: 'jkl012', steps: [{title: 'Step One'}]}
        workflow = Manifestly::Entity::Workflow.new(data)
        workflow.create
        expect(workflow.id).to be > 1
        expect(workflow.steps.first.title).to eq data[:steps].first[:title]
        expect(workflow.steps.first.id).to_not be_nil

        remote_workflow = Manifestly::Entity::Workflow.get(workflow.id)
        expect(remote_workflow).to be_a Manifestly::Entity::Workflow
        expect(remote_workflow.steps.first.title).to eq data[:steps].first[:title]
        expect(remote_workflow.steps.first.id).to_not be_nil

      ensure
        workflow&.delete rescue nil
      end
    end
  end

  describe 'block6' do
    it 'starts a checklist run' do
      workflow = nil
      checklist_run = nil
      begin
        my_email_address = ENV['API_KEY_EMAIL']
        my_user = Manifestly::Entity::User.list.find { |it| it.email == my_email_address }
        expect(my_user).to be_a Manifestly::Entity::User

        data = {title: 'Test Workflow for checklist run', external_id: 'mno345', steps: [{title: 'Step One'}]}
        workflow = Manifestly::Entity::Workflow.new(data).create
        expect(workflow).to be_a Manifestly::Entity::Workflow

        data = {title: "Test Run", checklist_id: workflow.id, users: [my_user.id]}
        checklist_run = Manifestly::Entity::ChecklistRun.new(data).create
        expect(checklist_run.id).to be > 1
        expect(Manifestly::Entity::ChecklistRun.get(checklist_run.id)).to be_a Manifestly::Entity::ChecklistRun

      ensure
        workflow&.delete rescue nil
        checklist_run&.delete rescue nil
      end
    end
  end

  describe 'block7' do
    it 'assigns and completes a step' do
      workflow = nil
      checklist_run = nil
      begin
        my_email_address = ENV['API_KEY_EMAIL']
        my_user = Manifestly::Entity::User.list.find { |it| it.email == my_email_address }
        expect(my_user).to be_a Manifestly::Entity::User

        data = {title: 'Test Workflow for checklist run step complete', external_id: 'pqr678', steps: [{title: 'Step One'}]}
        workflow = Manifestly::Entity::Workflow.new(data).create
        expect(workflow).to be_a Manifestly::Entity::Workflow

        data = {title: 'Test Run step complete', checklist_id: workflow.id, users: [my_user.id]}
        checklist_run = Manifestly::Entity::ChecklistRun.new(data).create
        expect(checklist_run.id).to be > 1

        checklist_run.steps.first.assign(my_user.id)
        expect(checklist_run.steps.first.assignee_user_id).to eq my_user.id

        expect(checklist_run.steps.first.completed_at).to be_nil
        checklist_run.steps.first.complete
        expect(checklist_run.steps.first.completed_at).to_not be_nil

      ensure
        workflow&.delete rescue nil
        checklist_run&.delete rescue nil
      end
    end
  end
end
