require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::User do
  describe '::endpoint_target' do
    subject { described_class.endpoint_target }

    it 'returns the path' do
      expect(subject).to eq :users
    end
  end
end
