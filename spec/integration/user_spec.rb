require 'spec_helper'
require 'manifestly'

describe Manifestly::Entity::User do
  before :all do
    WebMock.allow_net_connect!
  end

  after :all do
    WebMock.enable!
  end

  describe '.list' do
    subject { described_class.list }

    it 'returns an array of users' do
      expect(subject).to be_a Array
      subject.each { |it| expect(it).to be_a described_class }
    end
  end
end
