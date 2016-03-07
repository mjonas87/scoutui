# Ref
#   http://stackoverflow.com/questions/15164742/combining-implicit-wait-and-explicit-wait-together-results-in-unexpected-wait-ti#answer-15174978
# http://selenium.googlecode.com/svn-history/r15117/trunk/docs/api/rb/Selenium/WebDriver/Support/Select.html#selected_options-instance_method

module Scoutui::Commands

  class SelectObject < Command

    def execute(drv)
      @drv=drv if !drv.nil?

      _req = Scoutui::Utils::TestUtils.instance.getReq()
      obj=nil
      _rc=false

      begin

        if !@cmd.match(/select\(/).nil?

          _xpath = @cmd.match(/select\((.*),\s*/)[1].to_s
          _val   = @cmd.match(/select\(.*,\s*(.*)\)/)[1].to_s


          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "Process SELECT #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

          obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)

          if !obj.nil? && obj.tag_name.downcase.match(/(select)/)

            _opt = Selenium::WebDriver::Support::Select.new(obj)
            _opt.select_by(:text, Scoutui::Base::UserVars.instance.get(_val))

            _rc=true

      #      obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
          else
            Scoutui::Logger::LogMgr.instance.debug  __FILE__ + (__LINE__).to_s + " Unable to process command SELECT => #{obj.to_s}"
          end
        end

      rescue
        ;
      end

      Testmgr::TestReport.instance.getReq(_req).testcase('select').add(!obj.nil?, "Verify object to select exists #{_xpath} : #{obj.class.to_s}")
      Testmgr::TestReport.instance.getReq(_req).testcase('select').add(_rc, "Verify selected text #{_val}")
      setResult(_rc)

    end

  end


end
