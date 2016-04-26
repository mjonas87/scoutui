require_relative('./action')

module Scoutui::Actions
  STEP_KEY='step'

  def self.processActions(actionList, my_driver)
    actionList.each do |action|
      begin
        rc=processAction(action[:command], action[:e], my_driver)
      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.debug "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      end

    end

  end

  def self.processAction(_action, e, my_driver)
    Scoutui::Logger::LogMgr.instance.info "Command: ".yellow + "#{_action}".green

    _aborted=false

    rc=true
    _req = Scoutui::Utils::TestUtils.instance.getReq()

    begin

      _totalWindows = my_driver.window_handles.length
      Scoutui::Logger::LogMgr.instance.info "Total Windows: #{_totalWindows}".blue

      _c=nil

      if Scoutui::Actions::Utils.instance.isPause?(_action)
        _action='pause'
        _c = Scoutui::Actions::Pause.new(nil)
        _c.execute(e);
      elsif Scoutui::Actions::Utils.instance.isSelectWindow?(_action)
        _action='SelectWindow'
        _c = Scoutui::Actions::SelectWindow.new(_action)
        _c.execute(my_driver)
      elsif Scoutui::Actions::Utils.instance.isClick?(_action)
        _action='Click'
        _c = Scoutui::Actions::ClickObject.new(_action)
        _c.execute(my_driver)

        if e["page"].has_key?('then')
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " then => #{e[STEP_KEY]['then]']}"
        end

      elsif Scoutui::Actions::Utils.instance.isExistsAlert?(_action)
        _action='ExistsAlert'
        _c = Scoutui::Actions::JsAlert::ExistsAlert.new(_action)
        rc=_c.execute(my_driver)

      elsif Scoutui::Actions::Utils.instance.isGetAlert?(_action)
        _action='GetAlert'
        _c = Scoutui::Actions::ExistsAlert.new(_action)
        rc=_c.execute(my_driver)

      elsif  Scoutui::Actions::Utils.instance.isMouseOver?(_action)
        _action='MouseOver'
        _c = Scoutui::Actions::MouseOver.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Actions::Utils.instance.isSelect?(_action)
        _action='Select'
        _c = Scoutui::Actions::SelectObject.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Actions::Utils.instance.isFillForm?(_action)

        _action='FillForm'
         _c = Scoutui::Actions::FillForm.new(_action)

         _rc=false
         begin
          _form = _action.match(/fillform\((.*)\s*\)/)[1].to_s
          #  _dut = _action.match(/fillform\(.*,\s*(.*)\)/)[1].to_s

          dut = e[STEP_KEY]['dut']

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " DUT => #{dut}"
          _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
          _f.dump()
          _f.verifyForm(my_driver)
          _f.fillForm(my_driver, dut)
           _rc=true
         rescue
           ;
         end

        _c.setResult(_rc)

      elsif Scoutui::Actions::Utils.instance.isSubmitForm?(_action)
        _action='SubmitForm'
        _c = Scoutui::Actions::SubmitForm.new(_action)
        _c.execute(my_driver)


      elsif Scoutui::Actions::Utils.instance.isNavigate?(_action)
        _action='Navigate'
        _c = Scoutui::Actions::UpdateUrl.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Actions::Utils.instance.isVerifyElt?(_action)
        _action='VerifyElement'

        _c = Scoutui::Actions::VerifyElement.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Actions::Utils.instance.isType?(_action)
        _action='Type'
        _c = Scoutui::Actions::Type.new(_action)
        _c.execute(my_driver)
      else
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Unknown action : #{_action}"
        rc=false
      end

    rescue => e
      Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{$!}"
      Scoutui::Logger::LogMgr.instance.debug "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      _aborted=true
      rc=false
    end

    if my_driver.window_handles.length > _totalWindows
      Scoutui::Logger::LogMgr.instance.info " New Window generated from action #{_action}."
    end

    Testmgr::TestReport.instance.getReq(_req).get_child(_action.downcase).add(!_aborted, "Verify action #{_action} did not abort")
    _c
  end


end
