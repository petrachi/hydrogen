class Hydrogen::Seeder
  attr_accessor :name

  def initialize name
    @name = name
  end

  def seed
    stocks.map &:seed
  end


  def stocks
    Dir[File.join(File.dirname(__FILE__), "seeds", Hydrogen.name.to_s, "*.yml")].map do |file|
      Hydrogen::Stock.new file, seeder: self
    end
  end
end
