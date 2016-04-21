
#require 'eyes_selenium'
#require 'selenium-webdriver'

module Scoutui::Base


  class QBrowser

    attr_accessor :driver

    def initialize()
    end

    def self.wait_for_displayed(drv, locator, _timeout=30)
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " wait_for_displayed(#{xpath}"
      rc=nil
      begin
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { rc=drv.find_element(:xpath => xpath).displayed? }
      rescue => ex
        ;
      end
      rc
    end

    def self.wait_for_exist(drv, xpath, _timeout=30)
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " wait_for_exist(#{xpath}"
      rc=nil
      begin
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_element(:xpath => xpath) }
        rc=drv.find_element(:xpath => xpath)
      rescue => ex
        ;
      end
      rc
    end

    def self.getFirstObject(drv, locator, timeout = 30)
      first_object = nil

      begin
        locate_by = :xpath

        if locator.match(/^css\=/i)
          locate_by = :css
          locator = locator.match(/css\=(.*)/i)[1].to_s
        elsif locator.match(/^#/i)
          locate_by = :css
        end

        begin
          Selenium::WebDriver::Wait.new(timeout: timeout).until { drv.find_elements(locate_by => locator).size > 0 }
          first_object = drv.find_elements(locate_by => locator)[0]
          Scoutui::Logger::LogMgr.instance.info 'Wait'.blue + " : #{locator.yellow} : #{true.to_s.green}"
        rescue Selenium::WebDriver::Error::TimeOutError => ex
          Scoutui::Logger::LogMgr.instance.info 'Wait'.blue + " : #{locator.yellow} : #{ex.message.red}"
        end
      end

      first_object
    end

    # http://stackoverflow.com/questions/15164742/combining-implicit-wait-and-explicit-wait-together-results-in-unexpected-wait-ti#answer-15174978
    def self.getObject(drv, obj, _timeout=30)
      locateBy = :xpath

      if obj.is_a?(Hash)
        locator = obj['locator']
      elsif !obj.match(/^page\([\w\d]+\)/).nil?
        node = Scoutui::Utils::TestUtils.instance.getPageElement(obj)

        locator = if node.is_a?(Hash)
          node['locator'].to_s
        else
          node.to_s
        end
      else
        locator = obj.to_s
      end

      if !locator.match(/\$\{.*\}/).nil?
        _x = Scoutui::Base::UserVars.instance.get(locator)
        if !_x.nil?
          if !_x.match(/^page\([\w\d]+\)/).nil?
            elt = Scoutui::Utils::TestUtils.instance.getPageElement(_x)

            if elt.is_a?(Hash)
              locator = elt['locator'].to_s
            else
              locator=elt.to_s
            end
          end
        end
      end

      if locator.match(/^\s*css\s*\=\s*/i)
        locateBy = :css
        locator = locator.match(/css\s*\=\s*(.*)/i)[1].to_s
      elsif locator.match(/^#/i)
        locateBy = :css
      end

      binding.pry
      Selenium::WebDriver::Wait.new(timeout: _timeout).until { element = drv.find_element( locateBy => locator) }
      element
    end

    def wait_for(seconds)
      Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
    end

    def driver
      @driver
    end



  end


end
