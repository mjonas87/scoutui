require_relative 'version'

require 'forwardable'

class Scoutui::Navigator
  extend Forwardable

  attr_reader :test_options

  attr_reader :app_name
  attr_reader :test_name
  attr_reader :viewport_size
  attr_reader :driver
  attr_reader :test_list

  def initialize(opts={})

  end





end