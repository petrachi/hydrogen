class Hydrogen::Seeder
  attr_accessor :update, :reset

  def initialize update: false, reset: false
    @update = update
    @reset = reset
  end

  def seed
    stocks.map &:seed
  end


  def stocks
    Dir[File.join(Rails.root, "db", "hydrogen", "*.yml")].map do |file|
      Hydrogen::Stock.new file, seeder: self
    end
  end
end
