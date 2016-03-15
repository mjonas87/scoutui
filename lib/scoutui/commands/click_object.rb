require_relative './commands'

module Scoutui::Commands

  class ClickObject < Command


    def execute(drv)
      @drv=drv if !drv.nil?

      _xpath = @cmd.match(/click\s*\((.*)\)/)[1].to_s.strip
      Scoutui::Logger::LogMgr.instance.command.info __FILE__ + (__LINE__).to_s + " clickObject => #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      # _vars = _xpath.scan(/(\$\{.*?\})/)
      # _vars.each do | _v|
      #   if _v.length==1
      #
      #     _u = Scoutui::Base::UserVars.instance.get(_v[0].to_s)
      #     puts __FILE__ + (__LINE__).to_s + " Normalize(#{_v}) => #{_u}"
      #
      #     _xpath.gsub!(_v[0].to_s, _u)
      #   end
      #
      # end


      # _xpath = Scoutui::Base::UserVars.instance.get(_xpath)
      _xpath = Scoutui::Base::UserVars.instance.normalize(_xpath)

      Scoutui::Logger::LogMgr.instance.command.info __FILE__ + (__LINE__).to_s + " | translate : #{_xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?

      _clicked=false

      begin
        obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)

        if obj
          obj.click
          _clicked=true
        end

      rescue
        ;
      end

      Scoutui::Logger::LogMgr.instance.asserts.info "Verify object to click exists #{_xpath} : #{obj.class.to_s} - #{!obj.nil?.to_s}"
      Scoutui::Logger::LogMgr.instance.asserts.info "Verify clicked #{_xpath} - #{_clicked.to_s}"

      Testmgr::TestReport.instance.getReq('UI').testcase('click').add(!obj.nil?, "Verify object to click exists #{_xpath} : #{obj.class.to_s}")
      Testmgr::TestReport.instance.getReq('UI').testcase('click').add(_clicked, "Verify clicked #{_xpath}")

      setResult(_clicked)
    end

  end



end
