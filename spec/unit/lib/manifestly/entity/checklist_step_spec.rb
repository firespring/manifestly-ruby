require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::ChecklistStep do
  let(:instance) { described_class.new(checklist_run, data) }
  let(:checklist_run) { OpenStruct.new(path: run_path, id: run_id) }
  let(:run_path) { random }
  let(:run_id) { random }
  let(:data) { {} }

  before :each do
    allow(checklist_run).to receive(:is_a?).with(Manifestly::Entity::ChecklistRun).and_return(true)
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
        expect(checklist_run).to receive(:is_a?).with(Manifestly::Entity::ChecklistRun).and_return(false)
        expect { subject }.to raise_error(/invalid.*checklist.*run/i)
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

  describe '.path' do
    subject { described_class.path }
    it 'returns the path' do
      expect(subject).to eq 'run_steps'
    end
  end

  describe '.list' do
    subject { described_class.list(run) }
    let(:run) { OpenStruct.new(id: run_id, path: run_path) }
    let(:run_path) { random }
    let(:run_id) { random }
    let(:step_id) { random }
    let(:response) { {body: {described_class.path => [step_data]}.to_json} }
    let(:step_data) { random }
    let(:client) { Object.new }
    let(:step_instance) { random }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
      allow(client).to receive(:get)
    end

    it 'returns an array of entities' do
      expect(client).to receive(:get).with("#{run.path}/#{run.id}/#{described_class.path}").and_return(response)
      expect(described_class).to receive(:new).with(run, step_data).and_return(step_instance)
      expect(subject).to eq [step_instance]
    end
  end

  describe '.complete' do
    subject { instance.complete }
    let(:client) { Object.new }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the complete path' do
      instance.instance_variable_set(:@steps, nil)
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/complete")
      subject
      expect(instance.instance_variable_get(:@steps)).to be_nil
    end
  end

  describe '.uncomplete' do
    subject { instance.uncomplete }
    let(:client) { Object.new }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the uncomplete path' do
      instance.instance_variable_set(:@steps, nil)
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/uncomplete")
      subject
      expect(instance.instance_variable_get(:@steps)).to be_nil
    end
  end

  describe '.skip' do
    subject { instance.skip }
    let(:client) { Object.new }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the skip path' do
      instance.instance_variable_set(:@steps, nil)
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/skip")
      subject
      expect(instance.instance_variable_get(:@steps)).to be_nil
    end
  end

  describe '.unskip' do
    subject { instance.unskip }
    let(:client) { Object.new }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the unskip path' do
      instance.instance_variable_set(:@steps, nil)
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/unskip")
      subject
      expect(instance.instance_variable_get(:@steps)).to be_nil
    end
  end

  describe '.add_data' do
    subject { instance.add_data(value) }
    let(:client) { Object.new }
    let(:value) { random }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the data path' do
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/data", params: anything)
      subject
    end
  end

  describe '.add_picture' do
    subject { instance.add_picture(value) }
    let(:client) { Object.new }
    let(:value) { random }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the picture path' do
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/picture", params: anything)
      subject
    end
  end

  describe '.add_comment' do
    subject { instance.add_comment(value) }
    let(:client) { Object.new }
    let(:value) { random }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the comment path' do
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/comments", params: anything)
      subject
    end
  end

  describe '.assign' do
    subject { instance.assign(value) }
    let(:client) { Object.new }
    let(:value) { random }

    before :each do
      allow(described_class).to receive(:client).and_return(client)
    end

    it 'calls the assign path' do
      expect(client).to receive(:post).with("#{checklist_run.path}/#{checklist_run.id}/#{instance.path}/#{instance.id}/assign", params: anything)
      subject
    end
  end
end

















