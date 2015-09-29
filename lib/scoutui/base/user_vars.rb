require 'rubygems'
require 'singleton'

module Scoutui::Base

  class UserVars
    include Singleton

    attr_accessor :globals

    def initialize
      @globals={
          :userid => nil,
          :password => nil,
          :host => nil,
          :localization => 'en-us'
      }
    end

    def getHost()
      @globals[:host].to_s
    end

    def get(k)
      v=k

      if k=='${userid}'
        k=:userid
      elsif k=='${password}'
        k=:password
      elsif k=='${host}'
        k=:host
      end

      if @globals.has_key?(k)
        v=@globals[k]
      end
      v
    end

    def set(k, v)
      setVar(k, v)
      v
    end

    def setVar(k, v)
      @globals[k]=v
      v
    end


  end



end
