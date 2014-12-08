class Hydrogen::Stock
  attr_accessor :base, :yml
  attr_reader :seeder

  def initialize yml, seeder:;
    @base = File.basename(yml, ".yml").classify.constantize
    @yml = yml

    @seeder = seeder
  end

  def seed
    if !base.table_exists?
      Hydrogen::Logger.log "skipped `#{ base }' - Table doesn't exist", level: :debug
    elsif !base.acts_as_taggables?
      Hydrogen::Logger.log "skipped `#{ base }' - did not return `true' when asked `acts_as_taggables?'", level: :debug
    else
      if reset
        base.destroy_all
        Hydrogen::Logger.log "just reset `#{ base }' - this is what you asked for ;)", level: :info
      end
      seeds.map(&:seed!)
    end
  end


  delegate :update, :reset,
    to: :seeder


  def seeds
    YAML.load_file(yml).map do |tag, attributes|
      Hydrogen::Seed.new tag, attributes: attributes, stock: self
    end
  end
end
