class Hydrogen::Seed
  attr_accessor :tag, :attributes, :md_path
  attr_reader :stock

  def initialize tag, attributes:, stock:;
    @tag = tag
    @attributes = attributes

    @stock = stock

    @md_path = File.join(File.dirname(__FILE__), "seeds", name, base.name.tableize, "#{ tag }.md")
  end

  def seed
    create if should_create
  end


  delegate :base, :name,
    to: :stock


  def should_create
    !soul_mate
  end

  def create
    seed = base.create attributes
  ensure
    unless seed.valid?
      warn %Q{
  WARNING - Hydrogen failed to create '#{ base }##{ tag }',
    Here is the error report :
    #{ seed.errors.full_messages.join "/" }.
        }
    end
  end


  # TODO: soul mate detect from attributes
  # TODO: but You may want to detect only by tag (once tag are implemented)
  # TODO: and update the record if needed
  def soul_mate
    base.where(attributes).any?
  end


  def md
    File.read md_path
  end

  def attributes
    @attributes.merge tag: tag
  end
end
