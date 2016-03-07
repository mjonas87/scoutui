

module Scoutui::Commands

  class SubmitForm < Command

    attr_accessor :form_name

    def initialize(_cmd, _drv=nil)
      super(_cmd, _drv)
      @form_name = @cmd.match(/submitform\((.*)\s*\)/i)[1].to_s
    end

    def execute(drv=nil)
      _req = Scoutui::Utils::TestUtils.instance.getReq()

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Process SubmitForm #{@form_name}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      _rc=false

      begin
        @drv=drv if !drv.nil?

        obj = Scoutui::Utils::TestUtils.instance.getForm(@form_name)
        if !obj.nil?
          obj.submitForm(@drv)
          _rc=true
        end

      rescue
        ;
      end

      Testmgr::TestReport.instance.getReq(_req).get_child('submitform').add(_rc, "Verify form submitted.")

      setResult(_rc)
    end


  end



end
