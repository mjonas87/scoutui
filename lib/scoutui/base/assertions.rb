
require 'singleton'


module Scoutui::Base
  class Assertions
    include Singleton
    attr_accessor :drv

    def setDriver(_drv)
      @drv = _drv
    end

    def isVisible(driver, model_node, _req = nil)
      user_vars = Scoutui::Base::UserVars.new
      puts __FILE__ + (__LINE__).to_s + " [isVisible]: #{model_node}"

      rc =false
      cmd = 'visible'

      if _req.nil?
        _req = Scoutui::Utils::TestUtils.instance.getReq()
      end

      pageObject = model_node

      if model_node.is_a?(String) && model_node.match(/^\s*(text|value)\s*\(/)
        condition = model_node.match(/(value|text)\((.*)\)/)[1].to_s
        tmpObj = model_node.match(/(value|text)\((.*)\)/)[2].to_s
        expectedVal = model_node.match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s

        xpath = user_vars.get(tmpObj)
        obj = Scoutui::Base::QBrowser.getObject(driver, xpath)

        puts __FILE__ + (__LINE__).to_s + " #{condition} : #{obj.text}"

      elsif model_node.is_a?(String) && model_node.match(/^\s*(visible)\((.*)\)/)
        cmd = model_node.match(/(visible)\((.*)\)/)[1].to_s
        model_node = model_node.match(/(visible)\((.*)\)/)[2].to_s

        if !model_node.match(/\$\{.*\}/).nil?
          model_node = user_vars.normalize(model_node)
        end
      end

      if cmd=='visible' && model_node.is_a?(String) && model_node.match(/^\s*page\s*\(/)
        pageObject = Scoutui::Utils::TestUtils.instance.get_model_node(model_node)
      elsif !Scoutui::Actions::Utils.instance.isCSS(model_node).nil?
        pageObject={ 'locator' => Scoutui::Actions::Utils.instance.isCSS(model_node) }
      elsif cmd=='visible' && model_node.is_a?(String) && model_node.match(/^\s*\//)
        pageObject={ 'locator' => model_node }
      end

      if cmd == 'visible' && pageObject.is_a?(Hash) && pageObject.key?('locator')

        ##
        # expected:
        #   wait: page(abc).get(def)    where this model_node has "locator"

        locator = pageObject['locator'].to_s

        element = Scoutui::Base::QBrowser.getFirstObject(driver, locator)

        if cmd=='visible'
          if !element.nil?
            rc=element.displayed?
          end

          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{model_node} is visible - #{rc}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible').add(rc, "Verify #{model_node} is visible")
        end

        ## TITLE
      elsif model_node.is_a?(String) && model_node.match(/\s*(title)\s*\(\s*(.*)\s*\)/)
        current_title = driver.title.strip

        _t = model_node.match(/\s*title\s*\(\s*(.*)\s*\)/)[1].to_s

        expected_title = Regexp.new(_t)
        rc=!current_title.match(expected_title).nil?

        Scoutui::Logger::LogMgr.instance.asserts.info "Verify current title, #{current_title}, matches #{expected_title})"
        Testmgr::TestReport.instance.getReq(_req).get_child('title').add(rc, "Verify current title, #{current_title}, matches #{expected_title}")

      end

      rc

     end

    # { "visible_when" => "always" }
    def visible_when_always(model_key, model_node, element = nil, _req='UI')
      fail Exception, 'Assertion mismatch' unless model_node.key?('visible_when') && model_node['visible_when'].match(/always/i)

      locator = model_node['locator'].to_s

      if !locator.nil?
        Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!element.nil?, "Verify #{model_key} - #{locator} always visible")
        report_success("Visible?", locator, true)
        return true
      else
        report_failure("Visible?", locator, false)
        return false
      end
    end

    def visible_when_title(model_key, model_node, element, driver, _req='UI')
      Scoutui::Logger::LogMgr.instance.debug "Visible When Title: #{model_node.to_s}".blue

      _processed = false

      _req = 'UI' if _req.nil? || _req.empty?

      if model_node.key?('visible_when') && !model_node['visible_when'].is_a?(Array)  && model_node['visible_when'].match(/title\(/i)
        _processed=true

        current_title = driver.title.strip

        _t = model_node['visible_when'].match(/title\((.*)\)/)[1].to_s

        expected_title = Regexp.new(_t)
        rc=!current_title.match(expected_title).nil?


        Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{model_key} - object exists when expected title, #{expected_title}, matches actual title(#{current_title})"
        Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!element.nil? == rc, "Verify #{model_key} - object exists when expected title, #{expected_title}, matches actual title(#{current_title}) - #{rc}")


      end

      _processed
    end

    def visible_when_never(model_key, model_node, element=nil, _req='UI')
      Scoutui::Logger::LogMgr.instance.debug "Visible When Never: #{model_node.to_s}".blue
      rc = false

      fail Exception, "Node with key '#{model_key}' does not have a 'locator' attribute." unless model_node.key?('locator')
      locator = model_node['locator']

      if !locator.nil? &&  model_node.key?('visible_when')
        if model_node['visible_when'].is_a?(Array)
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when_never (array) - TBD"

        elsif  model_node['visible_when'].match(/never/i)
          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{model_key} #{locator} never visible - #{element.nil?.to_s}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(element.nil?, "Verify #{model_key} #{locator} never visible")
          rc=true
        end

      end

      rc
    end

    def visible_when_value(model_key, model_node, driver, _req='UI')
      Scoutui::Logger::LogMgr.instance.debug "Visible When Value: #{model_node.to_s}".blue

      _processed=false
      user_vars = Scoutui::Base::UserVars.new

      if model_node.key?('visible_when') && !model_node['visible_when'].is_a?(Array) && model_node['visible_when'].match(/^\s*(text|value)\s*\(/)
        _processed = true
        condition = model_node['visible_when'].match(/(value|text)\((.*)\)/)[1].to_s
        tmpObj = model_node['visible_when'].match(/(value|text)\((.*)\)/)[2].to_s
        expectedVal = model_node['visible_when'].match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s

        xpath = user_vars.get(tmpObj)
        obj = Scoutui::Base::QBrowser.getObject(driver, xpath)

        if !obj.nil?
          if obj.tag_name.downcase.match(/(select)/)
            _opt = Selenium::WebDriver::Support::Select.new(obj)
            opts = _opt.selected_options

            opts.each do |o|
              desc = if condition == 'text' && o.text == expectedVal
                "Verify #{locator} is visible since condition (#{condition} #{xpath} is met."
              elsif condition == 'value' && o.attribute('value').to_s == expectedVal
                "Verify #{locator} is visible since #{condition} of #{xpath} is #{expectedVal}"
              end

              fail Exception, 'Unable to determine description.' if desc.nil?

              locatorObj = Scoutui::Base::QBrowser.getObject(driver, locator)
              Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed?, desc)
            end

          else
            locator = model_node['locator']

            _rc=false

            if condition=='text'
              _rc=obj.text==expectedVal
              desc=" Verify #{model_key}, #{locator} is visible since condition '#{condition}' of #{xpath} is #{expectedVal}."
            elsif condition=='value'
              _rc=o.attribute('value').to_s==expectedVal
              desc=" Verify #{model_key}, #{locator}, is visible since condition '#{condition}' of #{xpath} is #{expectedVal}"
            end

            if !desc.nil?
              locatorObj = Scoutui::Base::QBrowser.getObject(driver, locator)

              Testmgr::TestReport.instance.getReq(_req).tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed? && _rc, desc)
            end
          end
        end
      end

      _processed
    end

    def assertPageElement(model_key, model_node, element, driver, _req)

      _processed = true

      if Scoutui::Base::Assertions.instance.visible_when_always(model_key, model_node, element, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_never(model_key, model_node, element, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_title(model_key, model_node, element, driver, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_value(model_key, model_node, driver, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_visible(model_key, model_node, element, driver, _req)
        ;
      else
        _processed = false
      end

      _processed

    end


    # _a : Hash
    # o locator => String
    # o visible_when => Hash
    def visible_when_visible(model_key, model_node, element, driver, _req='UI')

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " visible_when_visible(#{model_key}, #{model_node}, #{element}, mydriver, #{_req}"

      _processed = false
      if model_node.key?('visible_when') && !model_node['visible_when'].is_a?(Array) && model_node['visible_when'].match(/\s*visible\s*\(/)
        _processed = true

        condition = model_node['visible_when'].match(/(visible)\((.*)\)/)[1].to_s
        tmpObj = model_node['visible_when'].match(/(visible)\((.*)\)/)[2].to_s
        expectedVal = model_node['visible_when'].match(/(visible)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s

        user_vars = Scoutui::Base::UserVars.new
        locator = user_vars.get(tmpObj)
        depObj = Scoutui::Base::QBrowser.getObject(driver, locator)

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "condition (#{condition}), tmpObj (#{tmpObj}) (#{depObj}), expectedVal (#{expectedVal})  :  element : #{element.displayed?}"


        expectedRc = !expectedVal.match(/^\s*true\s*$/i).nil?


        _desc=" Verify #{model_key} is "
        if expectedRc == !depObj.nil?
          _desc+="visible when visible(#{tmpObj}) is #{expectedRc}"

          Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + _desc + " - #{!element.nil?}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when_visible').add(!element.nil?, __FILE__ + (__LINE__).to_s + _desc)

        else
          _desc += "not visible when visible(#{tmpObj}) is #{!depObj.nil?} (expected:#{expectedRc})"

          Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + _desc + " - #{element.nil?}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when_visible').add(element.nil?, __FILE__ + (__LINE__).to_s + _desc)
        end

      end

      _processed
    end

    private

    def report_success(expectation_text, element_selector, error_text)
      Scoutui::Logger::LogMgr.instance.info "#{expectation_text.blue} : #{element_selector.yellow} : #{error_text.to_s.green}"
    end

    def report_failure(expectation_text, element_selector, error_text)
      Scoutui::Logger::LogMgr.instance.info expectation_text.blue + ": #{element_selector.yellow}: #{error_text.to_s.red}"
    end
  end
end
