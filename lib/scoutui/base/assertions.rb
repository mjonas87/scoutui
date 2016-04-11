
require 'singleton'


module Scoutui::Base
  class Assertions
    include Singleton
    attr_accessor :drv

    def setDriver(_drv)
      @drv=_drv
    end

    def isVisible(my_driver, page_elt, _req=nil)
      puts __FILE__ + (__LINE__).to_s + " [isVisible]: #{page_elt}"

      rc=false
      cmd='visible'

      if _req.nil?
        _req = Scoutui::Utils::TestUtils.instance.getReq()
      end

      pageObject=page_elt

      if page_elt.is_a?(String) && page_elt.match(/^\s*(text|value)\s*\(/)
        condition = page_elt.match(/(value|text)\((.*)\)/)[1].to_s
        tmpObj = page_elt.match(/(value|text)\((.*)\)/)[2].to_s
        expectedVal = page_elt.match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s

        xpath = Scoutui::Base::UserVars.instance.get(tmpObj)
        obj = Scoutui::Base::QBrowser.getObject(my_driver, xpath)

        puts __FILE__ + (__LINE__).to_s + " #{condition} : #{obj.text}"

      elsif page_elt.is_a?(String) && page_elt.match(/^\s*(visible)\((.*)\)/)
        cmd = page_elt.match(/(visible)\((.*)\)/)[1].to_s
        page_elt = page_elt.match(/(visible)\((.*)\)/)[2].to_s

        if !page_elt.match(/\$\{.*\}/).nil?
          page_elt = Scoutui::Base::UserVars.instance.normalize(page_elt)
        end
      end

      if cmd=='visible' && page_elt.is_a?(String) && page_elt.match(/^\s*page\s*\(/)
        pageObject = Scoutui::Utils::TestUtils.instance.getPageElement(page_elt)
      elsif !Scoutui::Commands::Utils.instance.isCSS(page_elt).nil?
        pageObject={ 'locator' => Scoutui::Commands::Utils.instance.isCSS(page_elt) }
      elsif cmd=='visible' && page_elt.is_a?(String) && page_elt.match(/^\s*\//)
        pageObject={ 'locator' => page_elt }
      end

      if cmd == 'visible' && pageObject.is_a?(Hash) && pageObject.has_key?('locator')

        ##
        # expected:
        #   wait: page(abc).get(def)    where this page_elt has "locator"

        locator = pageObject['locator'].to_s

        _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, locator)

        if cmd=='visible'
          if !_obj.nil?
            rc=_obj.displayed?
          end

          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{page_elt} is visible - #{rc}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible').add(rc, "Verify #{page_elt} is visible")
        end

        ## TITLE
      elsif page_elt.is_a?(String) && page_elt.match(/\s*(title)\s*\(\s*(.*)\s*\)/)
        current_title = my_driver.title.strip

        _t = page_elt.match(/\s*title\s*\(\s*(.*)\s*\)/)[1].to_s

        expected_title = Regexp.new(_t)
        rc=!current_title.match(expected_title).nil?

        Scoutui::Logger::LogMgr.instance.asserts.info "Verify current title, #{current_title}, matches #{expected_title})"
        Testmgr::TestReport.instance.getReq(_req).get_child('title').add(rc, "Verify current title, #{current_title}, matches #{expected_title}")

      end

      rc

     end

    # { "visible_when" => "always" }
    def visible_when_always(_k, _v, _obj=nil, _req='UI')

      _locator=nil
      rc=false

      if _v.has_key?('visible_when') && _v['visible_when'].is_a?(Array)
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when_always (array) - TBD"
        return rc
      end

      if _v.has_key?('locator')
        _locator = _v['locator'].to_s
      end

      if !_locator.nil? &&  _v.has_key?('visible_when') && _v['visible_when'].match(/always/i)
          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} - #{_locator} always visible - #{(!_obj.nil?).to_s}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify #{_k} - #{_locator} always visible")
          rc=true
      end
      rc
    end

    def visible_when_title(_k, page_elt, _obj, my_driver, _req='UI')
      _processed=false

      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when_title(#{page_elt})"
      _req='UI' if _req.nil? || _req.empty?

      if page_elt.has_key?('visible_when') && !page_elt['visible_when'].is_a?(Array)  && page_elt['visible_when'].match(/title\(/i)
        _processed=true

        current_title = my_driver.title.strip

        _t = page_elt['visible_when'].match(/title\((.*)\)/)[1].to_s

        expected_title = Regexp.new(_t)
        rc=!current_title.match(expected_title).nil?


        Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} - object exists when expected title, #{expected_title}, matches actual title(#{current_title})"
        Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil? == rc, "Verify #{_k} - object exists when expected title, #{expected_title}, matches actual title(#{current_title}) - #{rc}")


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

      if !_locator.nil? &&  _v.has_key?('visible_when')

        if _v['visible_when'].is_a?(Array)
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when_never (array) - TBD"

        elsif  _v['visible_when'].match(/never/i)
          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} #{_locator} never visible - #{_obj.nil?.to_s}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(_obj.nil?, "Verify #{_k} #{_locator} never visible")
          rc=true
        end

      end

      rc
    end


    # { "visible_when" => true }
    def visible_when_skip(_k, _v)

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " visible_when_skip : #{_v.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
      rc=false

      if _v.is_a?(Hash) && _v.has_key?('visible_when')

        if _v['visible_when'].is_a?(Array)
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when_skip (array) - TBD"

        elsif _v['visible_when'].match(/skip/i)
          rc=true

          Scoutui::Logger::LogMgr.instance.asserts.info "Skip verify #{_k.to_s} - skipped"
          Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(nil, "Skip verify #{_k.to_s}")
        end

      end

      rc
    end



    def visible_when_value(_k, page_elt, my_driver, _req='UI')

      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when_value(#{_k}, #{page_elt})"

      _processed=false



      if page_elt.has_key?('visible_when') && !page_elt['visible_when'].is_a?(Array) && page_elt['visible_when'].match(/^\s*(text|value)\s*\(/)

        begin
          puts __FILE__ + (__LINE__).to_s + " ==> #{page_elt['visible_when'].match(/^\s*(text|value)\s*\(/)[1]}"

          _processed=true
          rc=nil

          condition = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[1].to_s
          tmpObj = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[2].to_s
          expectedVal = page_elt['visible_when'].match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s



          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " #{condition} => #{tmpObj} with expected value #{expectedVal}"

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

            else

              desc=nil

              locator = page_elt['locator']

              _rc=false

              if condition=='text'
                _rc=obj.text==expectedVal
                desc=" Verify #{_k}, #{locator} is visible since condition '#{condition}' of #{xpath} is #{expectedVal}."
              elsif condition=='value'
                _rc=o.attribute('value').to_s==expectedVal
                desc=" Verify #{_k}, #{locator}, is visible since condition '#{condition}' of #{xpath} is #{expectedVal}"
              end

              if !desc.nil?
                locatorObj = Scoutui::Base::QBrowser.getObject(my_driver, locator)

                Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "#{desc} : #{locatorObj} : #{!locatorObj.nil? && locatorObj.displayed? && _rc}"


                Testmgr::TestReport.instance.getReq(_req).tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed? && _rc, desc)
              end


            end

            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " value : #{obj.attribute('value').to_s}"
          end


        rescue => ex
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Error during processing: #{ex}"
          puts __FILE__ + (__LINE__).to_s +  "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"

        end


#      elsif page_elt.has_key?('visible_when') &&  page_elt['visible_when'].match(/\s*(text|value)\s*\(/)
#        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Unknown => #{page_elt}"

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
      elsif Scoutui::Base::Assertions.instance.visible_when_value(_k, _v, my_driver, _req)
        ;
      elsif Scoutui::Base::Assertions.instance.visible_when_visible(_k, _v, _obj, my_driver, _req)
        ;
      else
        _processed = false
      end

      _processed

    end


    # _a : Hash
    # o locator => String
    # o visible_when => Hash
    def visible_when_visible(_k, page_elt, _obj, my_driver, _req='UI')

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " visible_when_visible(#{_k}, #{page_elt}, #{_obj}, mydriver, #{_req}"

      _processed = false
      if page_elt.has_key?('visible_when') && !page_elt['visible_when'].is_a?(Array) && page_elt['visible_when'].match(/\s*visible\s*\(/)
        _processed = true

        condition = page_elt['visible_when'].match(/(visible)\((.*)\)/)[1].to_s
        tmpObj = page_elt['visible_when'].match(/(visible)\((.*)\)/)[2].to_s
        expectedVal = page_elt['visible_when'].match(/(visible)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s

        _locator = Scoutui::Base::UserVars.instance.get(tmpObj)
        depObj = Scoutui::Base::QBrowser.getObject(my_driver, _locator)

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "condition (#{condition}), tmpObj (#{tmpObj}) (#{depObj}), expectedVal (#{expectedVal})  :  _obj : #{_obj.displayed?}"


        expectedRc = !expectedVal.match(/^\s*true\s*$/i).nil?


        _desc=" Verify #{_k} is "
        if expectedRc == !depObj.nil?
          _desc+="visible when visible(#{tmpObj}) is #{expectedRc}"

          Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + _desc + " - #{!_obj.nil?}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when_visible').add(!_obj.nil?, __FILE__ + (__LINE__).to_s + _desc)

        else
          _desc+="not visible when visible(#{tmpObj}) is #{!depObj.nil?} (expected:#{expectedRc})"

          Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + _desc + " - #{_obj.nil?}"
          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when_visible').add(_obj.nil?, __FILE__ + (__LINE__).to_s + _desc)
        end

      end

      _processed
    end
  end
end
