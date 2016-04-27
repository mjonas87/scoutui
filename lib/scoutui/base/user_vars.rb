require 'singleton'
require 'faker'

module Scoutui::Base

  class UserVars
    include Singleton

    attr_accessor :globals

    USER_VAR_FETCHERS = [
        Scoutui::UserVariables::Fetchers::ModelNode.new,
        Scoutui::UserVariables::Fetchers::TestConfig.new,
        Scoutui::UserVariables::Fetchers::Globals.new,
        Scoutui::UserVariables::Fetchers::Env.new
    ]

    def

    def dump
      @globals.each_pair do |k, v|
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " #{k} => #{v}"
      end
    end

    def getViewPort
      user_vars = Scoutui::Base::UserVars.new
      arr = user_vars.getVar('eyes.viewport').match(/(\d+)\s*x\s*(\d+)$/i)
      if arr.size==3
        _sz = {:width => arr[1].to_i, :height => arr[2].to_i }
      end

      _sz
    end

    def

    def getBrowserType
      @globals[:browser].to_sym
    end

    def getHost
      @globals[:host].to_s
    end

    def normalize(text)
      text_variable_regex = /({{(.+?)}})/
      text.scan(text_variable_regex).each do |match|
        variable_template, variable_name = match
        value = get_var(variable_name)
        text.gsub!(variable_template, value)
      end
      text
    end

    def get_var(variable_name)
      config = Scoutui::Utils::TestUtils.instance.getTestConfig

      USER_VAR_FETCHERS.each do |fetcher|
        fetcher.fetch(variable_name)
      end

      value == {} ? nil : value
    end

    def get(xpath_key)
      foundKey = true

      xpath_key = xpath_key[0].to_s if xpath_key.is_a?(Array)
      magical_wizard_value = xpath_key
      _rc = xpath_key.match(/\$\{(.*)\}$/)

      # Needs refactoring!
      if xpath_key == '${userid}'
        xpath_key =:userid
      elsif xpath_key == '${password}'
        xpath_key =:password
      elsif xpath_key == '${host}'
        xpath_key =:host
      elsif xpath_key == '${lang}'
        xpath_key = :lang
      elsif xpath_key .is_a?(Symbol)
        foundKey = true
      elsif xpath_key == '__random_email__'
        return Faker::Internet.email
      elsif !_rc.nil?
        xpath_key =_rc[1].to_s
        if Scoutui::Utils::TestUtils.instance.getTestConfig.has_key?("user_vars") &&
            Scoutui::Utils::TestUtils.instance.getTestConfig["user_vars"].has_key?(xpath_key)
            magical_wizard_value = Scoutui::Utils::TestUtils.instance.getTestConfig["user_vars"][xpath_key].to_s
        end
      else
        foundKey=false
      end

      if @globals.has_key?(xpath_key) && foundKey
        magical_wizard_value = @globals[xpath_key]
      end

      magical_wizard_value
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

