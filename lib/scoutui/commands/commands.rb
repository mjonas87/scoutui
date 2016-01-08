require_relative('./command')

module Scoutui::Commands

  STEP_KEY='page'


  def self.processCommands(commandList, my_driver)

    commandList.each do |cmd|
      begin
        rc=processCommand(cmd[:command], cmd[:e], my_driver)
      rescue => ex
        puts "Error during processing: #{$!}"
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      end

    end

  end

  def self.processCommand(_action, e, my_driver)
    puts __FILE__ + (__LINE__).to_s + " ===  Process ACTION : #{_action}  ==="  if Scoutui::Utils::TestUtils.instance.isDebug?

    rc=true

    begin

      _c=nil

      if Scoutui::Commands::Utils.instance.isPause?(_action)
        _c = Scoutui::Commands::Pause.new(nil)
        _c.execute();

      elsif Scoutui::Commands::Utils.instance.isClick?(_action)
        _c = Scoutui::Commands::ClickObject.new(_action)
        _c.execute(my_driver)

      elsif  Scoutui::Commands::Utils.instance.isMouseOver?(_action)

        _c = Scoutui::Commands::MouseOver.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isSelect?(_action)
        _c = Scoutui::Commands::SelectObject.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isFillForm?(_action)

        #   _c = Scoutui::Commands::FillForm.new(_action)

        _form = _action.match(/fillform\((.*)\s*\)/)[1].to_s
        #  _dut = _action.match(/fillform\(.*,\s*(.*)\)/)[1].to_s

        dut = e[STEP_KEY]['dut']

        puts __FILE__ + (__LINE__).to_s + " DUT => #{dut}"
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.dump()
        _f.verifyForm(my_driver)
        _f.fillForm(my_driver, dut)

      elsif Scoutui::Commands::Utils.instance.isSubmitForm?(_action)
        _c = Scoutui::Commands::SubmitForm.new(_action)
        _c.execute(my_driver)


      elsif Scoutui::Commands::Utils.instance.isNavigate?(_action)
        _c = Scoutui::Commands::UpdateUrl.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isVerifyElt?(_action)

        _c = Scoutui::Commands::VerifyElement.new(_action)
        _c.execute(my_driver)

      elsif Scoutui::Commands::Utils.instance.isType?(_action)
        _c = Scoutui::Commands::Type.new(_action)
        _c.execute(my_driver)
      else
        rc=false
      end

    rescue => e
      puts "Error during processing: #{$!}"
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      rc=false
    end

    rc
  end





end
