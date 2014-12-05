module Hydrogen
  require 'hydrogen/seed'
  require 'hydrogen/seeder'
  require 'hydrogen/stock'
  require 'hydrogen/version'


  def seed **options
    Seeder.new(**options).seed
  end

  extend self
end
