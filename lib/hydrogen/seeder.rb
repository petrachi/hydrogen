class Hydrogen::Seeder
  attr_accessor :name, :update, :reset

  def initialize name, update: false, reset: false
    @name = name
    @update = update
    @reset = reset
  end

  # TODO: add an option (--force or --reset) wich will 'destroy_all' before seed
  def seed
    stocks.map &:seed
  end


  def stocks
    Dir[File.join(File.dirname(__FILE__), "seeds", Hydrogen.name.to_s, "*.yml")].map do |file|
      Hydrogen::Stock.new file, seeder: self
    end
  end
end
