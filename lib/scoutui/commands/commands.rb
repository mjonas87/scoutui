require_relative('./command')

module Scoutui::Commands

  STEP_KEY='page'


  def self.processCommands(commandList, my_driver)
    binding.pry

    commandList.each do |cmd|
      begin
        rc=processCommand(cmd[:command], cmd[:e], my_driver)
      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.debug "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      end

    end

  end

  def self.processCommand(_action, e, my_driver)
    Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " ===  Process ACTION : #{_action}  ==="

    _aborted=false
    _cmd=nil

    rc=true
    _req = Scoutui::Utils::TestUtils.instance.getReq()

    begin

      _totalWindows = my_driver.window_handles.length
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Total Windows : #{_totalWindows}"

      _c=nil

      if Scoutui::Commands::Utils.instance.isPause?(_action)
        _cmd='pause'
        _c = Scoutui::Commands::Pause.new(nil)
        _c.execute(e);
      elsif Scoutui::Commands::Utils.instance.isSelectWindow?(_action)
        _cmd='SelectWindow'
        _c = Scoutui::Commands::SelectWindow.new(_action)
        _c.execute(my_driver)
      elsif Scoutui::Commands::Utils.instance.isClick?(_action)
        _cmd='Click'
        _c = Scoutui::Commands::ClickObject.new(_action)
        _c.execute(my_driver)

        if e["page"].has_key?('then')
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " then => #{e['page']['then]']}"
        end

      elsif Scoutui::Commands::Utils.instance.isExistsAlert?(_action)
        _cmd='ExistsAlert'
        _c = Scoutui::Commands::JsAlert::ExistsAlert.new(_action)
        rc=_c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isGetAlert?(_action)
        _cmd='GetAlert'
        _c = Scoutui::Commands::ExistsAlert.new(_action)
        rc=_c.execute(my_driver)

      elsif  Scoutui::Commands::Utils.instance.isMouseOver?(_action)
        _cmd='MouseOver'
        _c = Scoutui::Commands::MouseOver.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isSelect?(_action)
        _cmd='Select'
        _c = Scoutui::Commands::SelectObject.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isFillForm?(_action)

        _cmd='FillForm'
         _c = Scoutui::Commands::FillForm.new(_action)

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

      elsif Scoutui::Commands::Utils.instance.isSubmitForm?(_action)
        _cmd='SubmitForm'
        _c = Scoutui::Commands::SubmitForm.new(_action)
        _c.execute(my_driver)


      elsif Scoutui::Commands::Utils.instance.isNavigate?(_action)
        _cmd='Navigate'
        _c = Scoutui::Commands::UpdateUrl.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isVerifyElt?(_action)
        _cmd='VerifyElement'

        _c = Scoutui::Commands::VerifyElement.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isType?(_action)
        _cmd='Type'
        _c = Scoutui::Commands::Type.new(_action)
        _c.execute(my_driver)
      else
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Unknown command : #{_action}"
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
      Scoutui::Logger::LogMgr.instance.info " New Window generated from command #{_cmd}."
    end

    Testmgr::TestReport.instance.getReq(_req).get_child(_cmd.downcase).add(!_aborted, "Verify command #{_cmd} did not abort")
    _c
  end


end
