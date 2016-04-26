require 'testmgr'

module Scoutui::Actions::JsAlert

  class ExistsAlert < Scoutui::Actions::Action


    def execute(drv=nil)
      @drv=drv if !drv.nil?

      _rc=nil
      _alertExists=false

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " command => #{@cmd.to_s}"

      _action=@cmd.match(/(exist[s]*_*alert|existAlert|existsAlert|existsJsAlert|existsJsConfirm|existsJsPrompt)\s*\((.*)\)/i)[2].to_s.strip

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " ExistsAlert(#{_action})"  if Scoutui::Utils::TestUtils.instance.isDebug?

      alert=nil

      begin
        alert=@drv.switch_to.alert
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " | alert => #{alert.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

        _alertExists = alert.is_a?(Selenium::WebDriver::Alert)
        if _alertExists && !(_action.nil? && _action.empty?)
          _r = Regexp.new _action.to_s

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " _r => #{_r}"
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " _t => #{alert.text.to_s}"
          _rc=!alert.text.to_s.match(_r).nil?
        end

      rescue Selenium::WebDriver::Error::NoSuchAlertError
        alert=nil
      end

      Testmgr::TestReport.instance.getReq('UI').testcase('expectJsAlert').add(_alertExists, "Verify JsAlert is present")

      if !(_action.nil? && _action.empty?)
        Testmgr::TestReport.instance.getReq('UI').get_child('expectJsAlert').add(_rc, "Verify JsAlert contains text #{_action}")


        setResult(_rc)
      end

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " ExistsAlert() => #{alert.class.to_s}    rc:#{_rc.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?


    end


  end



end
