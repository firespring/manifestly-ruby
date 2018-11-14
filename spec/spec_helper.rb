require 'ostruct'
require 'factory_bot'
require 'faker'
require 'rspec'
require 'simplecov'
require 'webmock'

SimpleCov.minimum_coverage 100
WebMock.enable!
require 'manifestly'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

require 'securerandom'
def random
  SecureRandom.hex
end

# Monkey patch rspec to allow us to test private methods.
#
# Basically, if you are working inside of a ```describe FooClass do...``` block,
# it takes the class you are describing and makes all of it's method public for the duration of
# the describe block. In this way we can test private methods inside of a class's describe, however
# they revert to private methods after.
class << RSpec
  alias_method :orig_describe, :describe

  def describe(*args, &example_group_block)
    example = orig_describe(*args, &example_group_block)

    klass = args[0]
    return unless klass.is_a? Class

    saved_private_instance_methods = klass.private_instance_methods(false)
    saved_private_class_methods = klass.singleton_class.private_instance_methods(false)

    example.before(:all) do
      klass.class_eval { public(*saved_private_instance_methods) }
      klass.class_eval { public_class_method(*saved_private_class_methods) }
    end

    example.after(:all) do
      klass.class_eval { private(*saved_private_instance_methods) }
      klass.class_eval { private_class_method(*saved_private_class_methods) }
    end
  end
end
