LIB_DIR = File.realpath(File.dirname(__FILE__))
$LOAD_PATH.unshift(LIB_DIR)
Dir["#{LIB_DIR}/**/*.rb"].each { |file| require file.sub("#{LIB_DIR}/", '').chomp('.rb') }

module Manifestly
  module DayOfTheWeek
    MONDAY = 'Monday'.freeze
    TUESDAY = 'Tuesday'.freeze
    WEDNESDAY = 'Wednesday'.freeze
    THURSDAY = 'Thursday'.freeze
    FRIDAY = 'Friday'.freeze
    SATURDAY = 'Saturday'.freeze
    SUNDAY = 'Sunday'.freeze
    WEEKDAY = [MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY].freeze
    WEEKEND = [SATURDAY, SUNDAY].freeze
  end

  module Duration
    MINUTES = 'minutes'.freeze
    HOURS = 'hours'.freeze
    DAYS = 'days'.freeze
  end
end
