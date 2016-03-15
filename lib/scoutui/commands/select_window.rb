
module Scoutui::Commands

  class SelectWindow < Command

    def execute(drv=nil)
      _rc=false
      _req = Scoutui::Utils::TestUtils.instance.getReq()
      _window_id=nil

      @drv=drv if !drv.nil?

      puts __FILE__ + (__LINE__).to_s + " SELECT WINDOW +++++++++++++++"

      begin
        _window_id = @cmd.match(/select_window\s*\((.*)\)/)[1].to_s.strip

        puts __FILE__ + (__LINE__).to_s + " ==> WindowID : #{_window_id}"
        puts __FILE__ + (__LINE__).to_s + " ==> handles  : #{@drv.window_handles.length.to_s}"

        i=0
        @drv.window_handles.each do |_w|
          puts __FILE__ + (__LINE__).to_s + "#{i}. #{_w.class.to_s}"
          @drv.switch_to.window(_w)
          puts __FILE__ + (__LINE__).to_s + " Title : #{@drv.title.to_s}"
        end

        _rc=true
      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.debug "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
      end

      Testmgr::TestReport.instance.getReq(_req).testcase('select_window').add(_rc, "Verify select_window #{_window_id} command passed #{_rc}")
      setResult(_rc)
    end



  end


end
