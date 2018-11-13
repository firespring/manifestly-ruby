require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::User do
  describe '::path' do
    subject { described_class.path }

    it 'returns the path' do
      expect(subject).to eq "users"
    end
  end
end
