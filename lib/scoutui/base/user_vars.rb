require 'singleton'
require 'faker'

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

    def getViewPort()
      arr=Scoutui::Base::UserVars.instance.getVar('eyes.viewport').match(/(\d+)\s*x\s*(\d+)$/i)
      if arr.size==3
        _sz = {:width => arr[1].to_i, :height => arr[2].to_i }
      end

      _sz
    end

    def getBrowserType()
      @globals[:browser].to_sym
    end

    def getHost()
      @globals[:host].to_s
    end

    def get(k)
      foundKey=true

      v=k

      _rc = k.match(/\$\{(.*)\}$/)

      # Needs refactoring!
      if k=='${userid}'
        k=:userid
      elsif k=='${password}'
        k=:password
      elsif k=='${host}'
        k=:host
      elsif k.is_a?(Symbol)
        foundKey=true
      elsif k=='__random_email__'
        return Faker::Internet.email
      elsif !_rc.nil?
        k=_rc[1].to_s
        puts __FILE__ + (__LINE__).to_s + " User Var found => #{k}"  if Scoutui::Utils::TestUtils.instance.isDebug?
        if Scoutui::Utils::TestUtils.instance.getTestConfig().has_key?("user_vars")

          if Scoutui::Utils::TestUtils.instance.getTestConfig()["user_vars"].has_key?(k)
            v=Scoutui::Utils::TestUtils.instance.getTestConfig()["user_vars"][k].to_s
          end

        end

      else
        foundKey=false
      end

      puts __FILE__ + (__LINE__).to_s + " get(#{k}) => #{@globals.has_key?(k)}" if Scoutui::Utils::TestUtils.instance.isDebug?

      if @globals.has_key?(k) && foundKey
        v=@globals[k]
      end

      puts __FILE__ + (__LINE__).to_s + " get(#{k} => #{@globals.has_key?(k)} ==> #{v.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

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
