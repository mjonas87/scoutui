require 'rubygems'
#require 'selenium-webdriver'

module Scoutui::Base

  class AppModel

    attr_accessor :drv
    attr_accessor :pages

    def initialize()
      @drv=nil
      @pages={}
    end

    def getPage(n)
      @pages[n]
    end

    def addPage(n, p)
      @pages[n]=p
    end

    def setup()
    end

  end



end
