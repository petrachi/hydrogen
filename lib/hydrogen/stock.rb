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
      warn "Hydrogen skipped '#{ base }': Table doesn't exist"
    elsif !base.acts_as_taggables?
      warn "Hydrogen skipped '#{ base }': RKit::ActiveRecordUtilities did not interfered with 'Tag'"
    else
      seeds.map(&:seed!)
    end
  end


  delegate :name,
    to: :seeder


  def seeds
    YAML.load_file(yml).map do |tag, attributes|
      Hydrogen::Seed.new tag, attributes: attributes, stock: self
    end
  end
end
