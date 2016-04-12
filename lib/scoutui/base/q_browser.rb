
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

    def self.getFirstObject(drv, _locator, _timeout=30)
      rc=nil
      locator=_locator

      begin
        locateBy=:xpath

        if _locator.match(/^css\=/i)
          locateBy = :css
          locator = _locator.match(/css\=(.*)/i)[1].to_s
        elsif _locator.match(/^#/i)
          locateBy = :css
        end

        Scoutui::Logger::LogMgr.instance.info "Waiting for element: #{locator}".blue
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_elements(locateBy => locator).size > 0 }
        rc=drv.find_elements(locateBy => locator)[0]
      # rescue => ex
      #   Scoutui::Logger::LogMgr.instance.debug "getFirstObject.Exception: #{locator.to_s} - #{ex}"
      end

      rc
    end

    # http://stackoverflow.com/questions/15164742/combining-implicit-wait-and-explicit-wait-together-results-in-unexpected-wait-ti#answer-15174978
    def self.getObject(drv, obj, _timeout=30)
      rc=nil
      visible_when=nil
      locator=obj
      locateBy=:xpath
      locator=nil

      begin

        if obj.is_a?(Hash)


          if obj.has_key?('visible_when')
            visible_when=!obj['visible_when'].match(/always/i).nil?
          end

          locator = obj['locator'].to_s


        elsif !obj.match(/^page\([\w\d]+\)/).nil?

          elt = Scoutui::Utils::TestUtils.instance.getPageElement(obj)

          if elt.is_a?(Hash)
            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " JSON or Hash => #{elt}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            locator = elt['locator'].to_s
          else
            locator=elt.to_s
          end

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Process page request #{obj} => #{locator}" if Scoutui::Utils::TestUtils.instance.isDebug?

        else
          locator=obj.to_s
        end

        if !locator.match(/\$\{.*\}/).nil?
          _x = Scoutui::Base::UserVars.instance.get(locator)
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " User specified user var : #{locator} ==> #{_x}"
          if !_x.nil?


            if !_x.match(/^page\([\w\d]+\)/).nil?
              elt = Scoutui::Utils::TestUtils.instance.getPageElement(_x)

              if elt.is_a?(Hash)
                Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " JSON or Hash => #{elt}" if Scoutui::Utils::TestUtils.instance.isDebug?
                locator = elt['locator'].to_s
              else
                locator=elt.to_s
              end
            end

          end

        end

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " locator : #{locator}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if locator.match(/^\s*css\s*\=\s*/i)
          locateBy = :css
          locator = locator.match(/css\s*\=\s*(.*)/i)[1].to_s
        elsif locator.match(/^#/i)
          locateBy = :css
        #  locator = locator.match(/\#(.*)/)[1].to_s
        end


        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " By      => #{locateBy.to_s}"
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Locator => #{locator}"
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Visible_When => #{visible_when}"

      #  Selenium::WebDriver::Wait.new(timeout: _timeout).until { drv.find_element(:xpath => locator).displayed? }
        # rc=drv.find_element(:xpath => locator)
        Selenium::WebDriver::Wait.new(timeout: _timeout).until { rc=drv.find_element( locateBy => locator) }


      rescue Selenium::WebDriver::Error::TimeOutError
          Scoutui::Logger::LogMgr.instance.debug __FILE__  + (__LINE__).to_s + " #{locator} time out."
          rc=nil

      rescue Selenium::WebDriver::Error::NoSuchElementError
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " #{locator} not found."
        rc=nil

      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.debug "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
      end

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " getObject(#{locator}) => #{rc.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

#      if rc.kind_of?(Selenium::WebDriver::Element)
#
#        if visible_when
#          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Displayed => #{rc.displayed?}"
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
