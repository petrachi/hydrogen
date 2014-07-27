class Hydrogen::Stock
  attr_accessor :base, :yml
  attr_reader :seeder

  def initialize yml, seeder:;
    @base = File.basename(yml, ".yml").classify.constantize
    @yml = yml

    @seeder = seeder
  end

  def seed
    seeds.map(&:seed) if base.table_exists?
  end


  delegate :name,
    to: :seeder


  def seeds
    YAML.load_file(yml).map do |tag, attributes|
      Hydrogen::Seed.new tag, attributes: attributes, stock: self
    end
  end
end
