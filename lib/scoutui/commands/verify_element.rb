require_relative './commands'

module Scoutui::Commands
  class VerifyElement < Command
    def _verify(elt)
      begin

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " VerifyElement._verify(#{elt})"

        _k = elt.keys[0].to_s
        a = elt[_k]

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Assert => #{_k} :  #{a.to_s}"

        #    _k = 'generic-assertion'
        _v={}

        if a.is_a?(Hash)
          _v=a

          _req = Scoutui::Utils::TestUtils.instance.getReq()

          if _v.has_key?('locator')
            _locator = _v['locator'].to_s
            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

            #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

            _obj = Scoutui::Base::QBrowser.getFirstObject(@drv, _locator, Scoutui::Commands::Utils.instance.getTimeout())

            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}"
          end

          if _v.has_key?('visible_when')

            if _v['visible_when'].match(/always/i)
              Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + " Verify assertion #{_k} - #{_locator} visible - #{!_obj.nil?.to_s}"
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{_k} - #{_locator} visible")
            elsif _v['visible_when'].match(/never/i)
              Scoutui::Logger::LogMgr.instance.asserts.info "Verify assertion #{_k} #{_locator} not visible - #{obj.nil?.to_s}"
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(obj.nil?, "Verify assertion #{_k} #{_locator} not visible")
            elsif _v['visible_when'].match(/role\=/i)
              _role = _v['visible_when'].match(/role\=(.*)/i)[1].to_s
              _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify assertion object exists if the role #{_role} matches expected role #{_expected_role.to_s}"

              if _role==_expected_role.to_s
                Scoutui::Logger::LogMgr.instance.asserts.info "Verify assertion #{_k} #{_locator}  visible when role #{_role} - #{!_obj.nil?.to_s}"
                Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{_k} #{_locator}  visible when role #{_role}")
              end

            end
          end


        end

      rescue => ex

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " abort processing."
        Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{ex}"
        puts __FILE__ + (__LINE__).to_s +  "\nBacktrace:\n\t#{ex.backtrace.join("\n\t")}"
      end

    end
    def execute(drv)
      @drv=drv if !drv.nil?
      _e=getLocator()

      if _e.nil?
        _e = @cmd.match(/(verifyelt|verifyelement)\s*\((.*)\)/)[2].to_s.strip
      end

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " verifyElement => #{_e}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      _xpath = Scoutui::Base::UserVars.instance.get(_e)

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " | translate : #{_xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?


      page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(_xpath)

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Process page request #{page_elt} => #{page_elt.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

      xpath=nil

      if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

        locator = Scoutui::Base::UserVars.instance.get(page_elt['locator'].to_s)


        if page_elt.has_key?('visible_when') && page_elt['visible_when'].match(/title\(/)
          current_title = @drv.title
          expected_title = Regexp.new(page_elt['visible_when'].match(/title\((.*)\)/)[1].to_s)
          rc=!expected_title.match(current_title).nil?



          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Verify expected title (#{current_title}) matches (#{expected_title}) => " + rc.to_s

#          Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(expected_title==current_title, "Verify title matches #{expected_title}")
        end


        if page_elt.has_key?('visible_when') && page_elt['visible_when'].match(/(text|value)\s*\(/)

          rc=nil


          condition = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[1].to_s
          tmpObj = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[2].to_s
          expectedVal = page_elt['visible_when'].match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " tmpObj => #{tmpObj} with expected value #{expectedVal}"

          xpath = Scoutui::Base::UserVars.instance.get(tmpObj)

          obj = Scoutui::Base::QBrowser.getObject(@drv, xpath)

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
                  locatorObj = Scoutui::Base::QBrowser.getObject(@drv, locator)

                  Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " LocatorObj : #{locatorObj} : #{!locatorObj.nil? && locatorObj.displayed?}"


                  Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed?, desc)
                end

              end



            end

            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " value : #{obj.attribute('value').to_s}"
          end

        end

      elsif page_elt.is_a?(Hash)

        page_elt.each do |elt|

          puts __FILE__ + (__LINE__).to_s + " ELT => #{elt} : #{elt.to_s}"
          puts __FILE__ + (__LINE__).to_s + "     ELT[0] : #{elt[0]}"
          puts __FILE__ + (__LINE__).to_s + "     ELT[1] : #{elt[1]}"

          if elt.is_a?(Array)
            _h={ elt[0] => elt[1] }

            _verify(_h)
          end

        end


      end

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " xpath : #{xpath}"


    end
  end
end
