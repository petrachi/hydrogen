module Hydrogen

  def seed **options
    require 'hydrogen/logger'
    require 'hydrogen/seed'
    require 'hydrogen/seeder'
    require 'hydrogen/stock'
    require 'hydrogen/version'

    Logger.config(**options.fetch(:logger, {}))
    Seeder.new(**options.except(:logger)).seed
  end

  extend self
end
