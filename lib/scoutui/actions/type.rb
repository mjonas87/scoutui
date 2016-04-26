

module Scoutui::Actions

  class Type < Action


    def execute(drv=nil)
      @drv=drv if !drv.nil?

      _rc=false
      _req = Scoutui::Utils::TestUtils.instance.getReq()

      begin
        _xpath = @cmd.match(/type[\!]*\((.*),\s*/)[1].to_s
        _val   = @cmd.match(/type[\!]*\(.*,\s*(.*)\)/)[1].to_s

        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)

        if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password|email)/).nil?


          if @cmd.match(/type\!/i)
            obj.clear
          end

          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
          _rc=true
        else
          Scoutui::Logger::LogMgr.instance.commands.debug  __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
        end

      rescue
        ;
      end

      Testmgr::TestReport.instance.getReq(_req).testcase('type').add(!obj.nil?, "Verify object #{_xpath} to type #{_val} exists : #{obj.class.to_s}")
      Testmgr::TestReport.instance.getReq(_req).testcase('type').add(_rc, "Verify typed data #{_rc}")
      setResult(_rc)

    end


  end



end
