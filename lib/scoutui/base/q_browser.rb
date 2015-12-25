
require 'eyes_selenium'
require 'selenium-webdriver'
#require 'testmgr'

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

    def self.getObject(drv, obj, _timeout=30)
      puts __FILE__ + (__LINE__).to_s + " getObject(#{obj})  class:#{obj.class.to_s}   hash : #{obj.is_a?(Hash)}"
      rc=nil
      visible_when=nil
      locator=obj

      begin

        if obj.is_a?(Hash)


          if obj.has_key?('visible_when')
            visible_when=!obj['visible_when'].match(/always/i).nil?
          end

          locator = obj['locator'].to_s


        elsif !obj.match(/^page\([\w\d]+\)/).nil?

          elt = Scoutui::Utils::TestUtils.instance.getPageElement(obj)

          if elt.is_a?(Hash)
            puts __FILE__ + (__LINE__).to_s + " JSON or Hash => #{elt}"
            locator = elt['locator'].to_s
          else
            locator=elt.to_s
          end

          puts __FILE__ + (__LINE__).to_s + " Process page request #{obj} => #{locator}" if Scoutui::Utils::TestUtils.instance.isDebug?

        end

        puts __FILE__ + (__LINE__).to_s + " Locator => #{locator}"
        puts __FILE__ + (__LINE__).to_s + " Visible_When => #{visible_when}"

        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_element(:xpath => locator).displayed? }
        rc=drv.find_element(:xpath => locator)
      rescue => ex
        puts "Error during processing: #{$!}"
        puts "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
      end

      puts __FILE__ + (__LINE__).to_s + " getObject(#{locator}) => #{rc.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

#      if rc.kind_of?(Selenium::WebDriver::Element)
#
#        if visible_when
#          puts __FILE__ + (__LINE__).to_s + " Displayed => #{rc.displayed?}"
#          Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(rc.displayed?, "Verify #{locator} is visible")
#        end
#
#      end

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
