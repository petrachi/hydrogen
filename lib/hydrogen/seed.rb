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
    @seed ||= base.where(tag: tag).first_or_initialize
  end


  def seed!
    create if should_create
  end


  delegate :base, :name,
    to: :stock


  def should_create
    # !soul_mate
    true
  end

  def create
    seed = base.where(tag: tag).first_or_initialize
  ensure
    if seed.update_attributes attributes
      warn "Hydrogen successfully seeded '#{ base }##{ tag }'"
    else
      warn %Q{
  WARNING - Hydrogen failed to seed '#{ base }##{ tag }',
    Here is the error report :
    #{ seed.errors.full_messages.join " + " }.
        }
    end
  end


  # TODO: soul mate detect from attributes
  # TODO: but You may want to detect only by tag (once tag are implemented)
  # TODO: and update the record if needed
  def soul_mate
    base.tagged(tag)
  end


  def md
    File.read md_path
  end

  def attributes
    @attributes.inject({}, &method(:typecast_attributes)).merge(tag: tag)
  end

  def typecast_attributes hash, (key, value)
    hash[key] = value if (value = typecast_attribute key, value)
    hash
  end

  def typecast_attribute key, value
    typecast = base.columns_hash[key.to_s].try :type

    case typecast
    when :boolean, :datetime
      value.send "to_#{ typecast }"
    # when :text
    #  TODO: .md file parser
    #  read md file if exist
    when nil
      typecast_association key, value
    else
      value
    end
  end

  def typecast_association key, value
    seed.association(key).klass.find_by(tag: value) if seed.association(key)
  end
end
