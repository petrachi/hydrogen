class Hydrogen::Stock
  attr_accessor :base, :dir
  attr_reader :seeder

  def initialize dir, seeder:;
    @base = File.basename(dir).classify.safe_constantize
    @dir = dir

    @seeder = seeder
  end

  def seed
    if !base
      Hydrogen::Logger.log "skipped `#{ File.basename(dir).classify }' - Uninitialized constant", level: :debug
    elsif !base.table_exists?
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
    Dir[File.join(dir, "*.yml")].map do |file|
      Hydrogen::Seed.new File.basename(file, '.yml'),
        attributes: YAML.load_file(file),
        stock: self
    end
  end
end
