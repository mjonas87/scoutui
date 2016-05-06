require 'singleton'
require 'faker'

module Scoutui::Base
  class UserVars
    include Singleton

    def initialize(fetchers = [])
      @fetchers = fetchers unless fetchers.size == 0
    end

    def global_fetcher
      @global_fetcher ||= Scoutui::UserVariables::Fetchers::Globals.new
    end

    def user_var_fetchers
      @fetchers ||= [
              Scoutui::UserVariables::Fetchers::TestConfig.new,
              global_fetcher,
              Scoutui::UserVariables::Fetchers::Env.new
          ]
    end

    def with_fetcher_for_node(model_node)
      clone = Scoutui::Base::UserVars.send(:new, self.user_var_fetchers)
      klass = Scoutui::UserVariables::Fetchers::ModelNode

      unless clone.user_var_fetchers.any? { |fetcher| fetcher.class == klass}
        clone.user_var_fetchers.unshift(klass.new(model_node))
      end

      clone
    end

    def with_fetcher_for_browser(driver)
      clone = Scoutui::Base::UserVars.send(:new, self.user_var_fetchers)
      klass = Scoutui::UserVariables::Fetchers::Browser

      unless clone.user_var_fetchers.any? { |fetcher| fetcher.class == klass}
        clone.user_var_fetchers.unshift(klass.new(driver))
      end

      clone
    end

    def dump
      global_fetcher.var_hash.each_pair do |k, v|
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " #{k} => #{v}"
      end
    end

    def getViewPort
      arr = getVar('eyes.viewport').match(/(\d+)\s*x\s*(\d+)$/i)
      if arr.size==3
        _sz = {:width => arr[1].to_i, :height => arr[2].to_i }
      end

      _sz
    end

    def getBrowserType
      global_fetcher.var_hash[:browser].to_sym
    end

    def getHost
      global_fetcher.var_hash[:host].to_s
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

    def fill(variable_name)
      get_var(variable_name)
    end

    def get_var(variable_name)
      user_var_fetchers.each do |fetcher|
        result = fetcher.fetch(variable_name)
        return result unless result.nil?
      end
      variable_name
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

      if global_fetcher.var_hash.has_key?(xpath_key) && foundKey
        magical_wizard_value = global_fetcher.var_hash[xpath_key]
      end

      magical_wizard_value
    end

    def set(k, v)
      setVar(k, v)
      v
    end

    def getVar(k)
      global_fetcher.var_hash[k].to_s
    end

    def setVar(k, v)
      global_fetcher.var_hash[k]=v
      v
    end
  end
end

