module Hydrogen
  require "hydrogen/seed"
  require "hydrogen/seeder"
  require "hydrogen/stock"
  require "hydrogen/version"


  def seed
    Seeder.new(name).seed
  end

  def name
    Rails.application.class.parent_name.underscore
  end

  extend self
end
