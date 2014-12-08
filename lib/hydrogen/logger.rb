class Hydrogen::Logger

  LEVELS = %i{info debug quiet}

  class << self
    attr_accessor :level, default: :info

    def config **options
      options.each do |name, value|
        send "#{ name }=", value
      end
    end
  end


  def self.log text, level:;
    new(text, level: level).log
  end


  attr_accessor :text, :level

  def initialize text, level: :info
    @text = text
    @level = level
  end

  def should_log?
    LEVELS.index(level) >= LEVELS.index(__class__.level)
  end

  depend on: :should_log? do
    def log
      warn %Q{
  HYDROGEN: #{ text }
      }
    end
  end

end
