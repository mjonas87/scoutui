require_relative './commands'

module Scoutui::Commands

  class VerifyElement < Command




    def execute(drv)
      @drv=drv if !drv.nil?
      _e=getLocator()

      if _e.nil?
        _e = @cmd.match(/verifyelt\s*\((.*)\)/)[1].to_s.strip
      end

      puts __FILE__ + (__LINE__).to_s + " verifyElement => #{_e}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      _xpath = Scoutui::Base::UserVars.instance.get(_e)

      puts __FILE__ + (__LINE__).to_s + " | translate : #{_xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?


      page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(_xpath)

      puts __FILE__ + (__LINE__).to_s + " Process page request #{page_elt} => #{page_elt.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

      xpath=nil

      if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

        locator = Scoutui::Base::UserVars.instance.get(page_elt['locator'].to_s)




        if page_elt.has_key?('visible_when') && page_elt['visible_when'].match(/(text|value)\s*\(/)

          rc=nil


          condition = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[1].to_s
          tmpObj = page_elt['visible_when'].match(/(value|text)\((.*)\)/)[2].to_s
          expectedVal = page_elt['visible_when'].match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s
          puts __FILE__ + (__LINE__).to_s + " tmpObj => #{tmpObj} with expected value #{expectedVal}"

          xpath = Scoutui::Base::UserVars.instance.get(tmpObj)

          obj = Scoutui::Base::QBrowser.getObject(@drv, xpath)

          if !obj.nil?
          #  puts __FILE__ + (__LINE__).to_s + " value : #{obj.value.to_s}"
            puts __FILE__ + (__LINE__).to_s + " text  : #{obj.text.to_s}"

            if obj.tag_name.downcase.match(/(select)/)
              _opt = Selenium::WebDriver::Support::Select.new(obj)
              opts = _opt.selected_options
              puts __FILE__ + (__LINE__).to_s + " selected => #{opts.to_s}"



              opts.each do |o|
                puts __FILE__ + (__LINE__).to_s + "| <v, t>::<#{o.attribute('value').to_s},  #{o.text.to_s}>"

                desc=nil


                if condition=='text' && o.text==expectedVal
                  desc=" Verify #{locator} is visible since condition (#{condition} #{xpath} is met."
                elsif condition=='value' && o.attribute('value').to_s==expectedVal
                  desc=" Verify #{locator} is visible since #{condition} of #{xpath} is #{expectedVal}"
                end

                if !desc.nil?
                  locatorObj = Scoutui::Base::QBrowser.getObject(@drv, locator)

                  puts __FILE__ + (__LINE__).to_s + " LocatorObj : #{locatorObj} : #{!locatorObj.nil? && locatorObj.displayed?}"


                  Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed?, desc)
                end

              end



            end

            puts __FILE__ + (__LINE__).to_s + " value : #{obj.attribute('value').to_s}"
          end




        end

      end

      puts __FILE__ + (__LINE__).to_s + " xpath : #{xpath}"


    end

  end



end
