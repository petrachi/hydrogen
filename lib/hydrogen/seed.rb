class Hydrogen::Seed
  attr_accessor :tag, :attributes, :md_path
  attr_reader :stock, :tags

  def initialize tag, attributes:, stock:;
    @tag = tag
    @attributes = attributes

    @stock = stock
    @tags = base.pluck(:tag)

    @md_paths = Dir[File.join(Rails.root, "db", "hydrogen", base.tableize, tag, "*.md")]
  end

  def seed
    @seed ||= base.where(tag: tag).first_or_initialize
  end


  def seed!
    if should_seed?
      create
    else
      Hydrogen::Logger.log %Q{skipped `#{ base }##{ tag }' - already exists.
  If you want to force update, set `update' param to `true'}, level: :debug
    end
  end


  delegate :base, :update,
    to: :stock


  def should_seed?
    update || !soul_mate
  end

  def create
    if seed.update_attributes attributes
      Hydrogen::Logger.log "successfully seeded '#{ base }##{ tag }'", level: :info
    else
      Hydrogen::Logger.log %Q{failed to seed '#{ base }##{ tag }',
  Here is the error report :
    #{ seed.errors.full_messages.join "\n" }
        }, level: :debug
    end
  end


  def soul_mate
    tags.include? tag
  end


  def md
    File.read md_path
  end

  def attributes
    {tag: tag}.tap do |attributes|

      @attributes.inject attributes, &method(:typecast_attributes)

      @md_paths.inject attributes do |hash, path|
        hash[File.basename(path, ".md")] =
          RKit::Parser::Base.parse(path,
            frame: Struct.new(*attributes.keys).new(*attributes.values)
          )
        hash
      end
    end
  end

  def typecast_attributes hash, (key, value)
    hash[key] = value if (value = typecast_attribute key, value)
    hash
  end

  def typecast_attribute key, value
    typecast = base.columns_hash[key.to_s].try :type

    case typecast
    when :datetime
      value.send "to_#{ typecast }"
    when nil
      typecast_association key.to_sym, value
    else
      value
    end
  end

  def typecast_association key, value
    seed.reflections.keys.include?(key).then do |_|
      seed.association(key).klass.find_by(tag: value)
    end
  end

end
