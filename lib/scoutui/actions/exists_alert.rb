

module Scoutui::Actions

  class ExistsAlert < Action


    def execute(drv=nil)
      @drv=drv if !drv.nil?

      _action = @cmd.match(/(get_*alert|clickjsconfirm|clickjsprompt|clickjsalert)\s*\((.*)\)/i)[2].to_s.strip

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " ExistsAlert(#{_action})"  if Scoutui::Utils::TestUtils.instance.isDebug?

      rc=false

      alert=nil

      begin
        alert=@drv.switch_to.alert

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " | alert => #{alert.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if alert.is_a?(Selenium::WebDriver::Alert)
          if _action.match(/accept/i)
            alert.accept
          elsif _action.match(/dismiss/i)
            alert.dismiss
          end

          rc=true
        end


      rescue Selenium::WebDriver::Error::NoSuchAlertError
        ;
      end

      _req = Scoutui::Utils::TestUtils.instance.getReq()

      Testmgr::TestReport.instance.getReq(_req).testcase(_action).add(!alert.nil?, "Verify alert exists")
      Testmgr::TestReport.instance.getReq(_req).testcase(_action).add(rc, "Verify processed alert")

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " ExistsAlert() => #{rc.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?
      rc

    end


  end



end
