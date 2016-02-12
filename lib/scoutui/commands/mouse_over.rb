
module Scoutui::Commands

  class MouseOver < Command

    def execute(drv=nil)
      _rc=false

      @drv=drv if !drv.nil?

      begin
        _xpath = @cmd.match(/mouseover\s*\((.*)\)/)[1].to_s.strip
        obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)
        @drv.action.move_to(obj).perform
        _rc=true
      rescue
        ;
      end

      Testmgr::TestReport.instance.getReq('UI').testcase('mouseover').add(!obj.nil?, "Verify object #{_xpath} to mouseover exists : #{obj.class.to_s}")
      Testmgr::TestReport.instance.getReq('UI').testcase('mousseover').add(_rc, "Verify mouseover #{_rc}")
      setResult(_rc)
    end



  end


end
