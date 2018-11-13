require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::ChecklistRun do
  let(:instance) { described_class.new }

  describe '::path' do
    subject { described_class.path }

    it 'returns the path' do
      expect(subject).to eq "runs"
    end
  end

  describe 'users=' do
    subject { instance.users = users }

    context 'user is an id' do
      let(:users) { [user_id] }
      let(:user_id) { random }

      before :each do
        allow(user_id).to receive(:is_a?).with(Integer).and_return(true)
      end

      it 'sets attribute to an array of ids' do
        subject
        expect(instance.users).to eq(users)
      end
    end

    context 'user is a user hash' do
      let(:users) { [id: user_id] }
      let(:user_id) { random }

      it 'sets attribute to an array of ids' do
        subject
        expect(instance.users).to eq([user_id])
      end
    end

    context 'user is invalid' do
      let(:users) { [Object.new] }

      it 'raises error' do
        expect { subject }.to raise_error(/invalid.*user.*value/i)
      end
    end
  end

  describe 'steps' do
    subject { instance.steps }
    let(:steps) { [Object.new] }

    before :each do
      instance.instance_variable_set(:@steps, nil)
    end

    it 'calls list' do
      expect(Manifestly::Entity::ChecklistStep).to receive(:list).with(instance).and_return(steps)
      expect(subject).to eq steps
    end
  end
end
