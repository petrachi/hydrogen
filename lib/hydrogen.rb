require "hydrogen/seed"
require "hydrogen/stock"
require "hydrogen/seeder"

require "hydrogen/version"

module Hydrogen
  def seed
    Seeder.new(name).seed
  end

  def name
    Rails.application.class.parent_name.underscore
  end

  extend self
end
