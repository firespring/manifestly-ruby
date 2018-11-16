require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::ChecklistRun do
  let(:instance) { described_class.new }

  describe '::endpoint_target' do
    subject { described_class.endpoint_target }

    it 'returns the endpoint_target' do
      expect(subject).to eq :runs
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
          steps = random
          expect(Manifestly::Entity::ChecklistRunStep).to receive(:list).with(instance).and_return(steps)
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
end
