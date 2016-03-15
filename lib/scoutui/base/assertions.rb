
require 'singleton'


module Scoutui::Base


  class Assertions
    include Singleton

    attr_accessor :drv


    def setDriver(_drv)
      @drv=_drv
    end

    # { "visible_when" => "always" }
    def visible_when_always(_k, _v, _obj=nil, _req='UI')

      _locator=nil
      rc=false
      if _v.has_key?('locator')
        _locator = _v['locator'].to_s
      end

      if !_locator.nil? &&  _v.has_key?('visible_when') && _v['visible_when'].match(/always/i)
          Scoutui::Logger::LogMgr.instance.info "Verify #{_k} - #{_locator} always visible - #{!_obj.nil?.to_s}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify #{_k} - #{_locator} always visible")
          rc=true
      end
      rc
    end

    def visible_when_title(_k, page_elt, _obj, my_driver, _req='UI')
      _processed=false

      _req='UI' if _req.nil? || _req.empty?

      if page_elt.has_key?('visible_when') && page_elt['visible_when'].match(/title\(/i)
        _processed=true

        current_title = my_driver.title.strip

        _t = page_elt['visible_when'].match(/title\((.*)\)/)[1].to_s

        expected_title = Regexp.new(_t)
        rc=!current_title.match(expected_title).nil?


          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil? == rc, "Verify object exists when expected title, #{expected_title}, matches actual title(#{current_title})")


      end

      _processed
    end

    def visible_when_never(_k, _v, _obj=nil, _req='UI')

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " visible_when_never(#{_k}, #{_v}, #{_obj}, #{_req})"
      _locator=nil
      rc=false

      if  _v.has_key?('locator')
        _locator=_v['locator']
      end

      if !_locator.nil? &&  _v.has_key?('visible_when') && _v['visible_when'].match(/never/i)
        Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} #{_locator} not visible - #{_obj.nil?.to_s}"
        Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(_obj.nil?, "Verify #{_k} #{_locator} not visible")
        rc=true
      end

      rc
    end


    # { "visible_when" => true }
    def visible_when_skip(_k, _v)

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " visible_when_skip : #{_v.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
      rc=false

      if _v.is_a?(Hash) && _v.has_key?('visible_when') && _v['visible_when'].match(/skip/i)
        rc=true

        Scoutui::Logger::LogMgr.instance.asserts.info "Skip verify #{_k.to_s} - skipped"
        Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(nil, "Skip verify #{_k.to_s}")
      end

      rc
    end



    def visible_when_value(_k, page_elt, my_driver, _req='UI')

      _processed=false

      if page_elt.has_key?('visible_when') && page_elt['visible_when'].match(/(text|value)\s*\(/)

        _processed=true
        rc=nil


        condition = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[1].to_s
        tmpObj = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[2].to_s
        expectedVal = page_elt['visible_when'].match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " tmpObj => #{tmpObj} with expected value #{expectedVal}"

        xpath = Scoutui::Base::UserVars.instance.get(tmpObj)

        obj = Scoutui::Base::QBrowser.getObject(my_driver, xpath)

        if !obj.nil?
          #  Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " value : #{obj.value.to_s}"
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " text  : #{obj.text.to_s}"

          if obj.tag_name.downcase.match(/(select)/)
            _opt = Selenium::WebDriver::Support::Select.new(obj)
            opts = _opt.selected_options
            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " selected => #{opts.to_s}"



            opts.each do |o|
              Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "| <v, t>::<#{o.attribute('value').to_s},  #{o.text.to_s}>"

              desc=nil


              if condition=='text' && o.text==expectedVal
                desc=" Verify #{locator} is visible since condition (#{condition} #{xpath} is met."
              elsif condition=='value' && o.attribute('value').to_s==expectedVal
                desc=" Verify #{locator} is visible since #{condition} of #{xpath} is #{expectedVal}"
              end

              if !desc.nil?
                locatorObj = Scoutui::Base::QBrowser.getObject(my_driver, locator)

                Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " LocatorObj : #{locatorObj} : #{!locatorObj.nil? && locatorObj.displayed?}"


                Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed?, desc)
              end

            end

          end

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " value : #{obj.attribute('value').to_s}"
        end


        puts __FILE__ + (__LINE__).to_s + " Pause for text()"
      end

      _processed

    end



    def assertPageElement(_k, _v, _obj, my_driver, _req)

      _processed = true

      if Scoutui::Base::Assertions.instance.visible_when_always(_k, _v, _obj, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_never(_k, _v, _obj, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_title(_k, _v, _obj, my_driver, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_value(_k, page_elt, my_driver, _req)
        ;
      else
        _processed = false
      end

      _processed

    end


    # _a : Hash
    # o locator => String
    # o visible_when => Hash
    def visible_when_visible(_a)

    end

  end



end