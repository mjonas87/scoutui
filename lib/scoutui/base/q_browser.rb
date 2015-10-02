
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

    def self.getObject(drv, xpath, _timeout=30)
      rc=nil
      begin
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_element(:xpath => xpath).displayed? }
        rc=drv.find_element(:xpath => xpath)
      rescue => ex
        ;
      end
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
