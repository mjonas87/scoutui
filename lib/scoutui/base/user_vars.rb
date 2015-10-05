require 'singleton'

module Scoutui::Base

  class UserVars
    include Singleton

    attr_accessor :globals

    def initialize
      @globals={
          :accounts => '/tmp/qa/accounts.yaml',
          :browser => 'chrome',
          :userid => nil,
          :password => nil,
          :host => nil,
          :localization => 'en-us'
      }
    end

    def dump()
      @globals.each_pair do |k, v|
        puts __FILE__ + (__LINE__).to_s + " #{k} => #{v}"
      end
    end

    def getBrowserType()
      @globals[:browser].to_sym
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

      puts __FILE__ + (__LINE__).to_s + " get(#{k} => #{@globals.has_key?(k)}"

      if @globals.has_key?(k)
        v=@globals[k]
      end
      v
    end

    def set(k, v)
      setVar(k, v)
      v
    end

    def getVar(k)
      @globals[k].to_s
    end

    def setVar(k, v)
      @globals[k]=v
      v
    end


  end



end
