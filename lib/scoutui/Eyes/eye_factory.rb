require 'rubygems'
require 'singleton'

module Scoutui::Eyes


  class EyeFactory
    include Singleton

    attr_accessor :eyesList

    def initialize
      @eyesList=Array.new()
    end

    def create(use_eyes=false)

      puts __FILE__ + (__LINE__).to_s + " create(#{use_eyes})"
      eyes=nil

      if use_eyes
        eyes=Applitools::Eyes.new()
        eyes.api_key = 'dHntgIngYlRjYuG5RmdjqOFk106XDCKJplGklCXzjsWjk110'
        eyes.force_fullpage_screenshot = true
      end

      eyes
    end

  end



end
