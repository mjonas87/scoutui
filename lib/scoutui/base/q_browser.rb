
require 'eyes_selenium'
require 'selenium-webdriver'


module Scoutui::Base


  class QBrowser

    attr_accessor :driver

    def initialize()
    end

    def self.wait_for_exist(drv, xpath, _timeout=30)
      puts __FILE__ + (__LINE__).to_s + " wait_for_exist(#{xpath}"
      rc=nil
      begin
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_element(:xpath => xpath) }
        rc=drv.find_element(:xpath => xpath)
      rescue => ex
        ;
      end
      rc
    end

    def self.getFirstObject(drv, xpath, _timeout=30)
      rc=nil
      begin
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_elements(:xpath => xpath).size > 0 }
        rc=drv.find_elements(:xpath => xpath)[0]
      rescue => ex
        ;
      end
      rc
    end

    def self.getObject(drv, xpath, _timeout=30)
      rc=nil
      begin

        if !xpath.match(/^page\([\w\d]+\)/).nil?

          xpath = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)
          puts __FILE__ + (__LINE__).to_s + " Process page request #{xpath} => #{xpath}"
        end


        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_element(:xpath => xpath).displayed? }
        rc=drv.find_element(:xpath => xpath)
      rescue => ex
        ;
      end

      puts __FILE__ + (__LINE__).to_s + " getObject(#{xpath}) => #{rc.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

      rc
    end

    def wait_for(seconds)
      Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
    end

    def driver
      @driver
    end



  end


end
