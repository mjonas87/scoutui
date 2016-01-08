

module Scoutui::Commands

  class Pause < Command

    def execute(drv=nil)
      rc=true
        begin
        puts "====== PAUSE - HIT ENTER ========="
        gets()
      rescue => e
        puts "Error during processing: #{$!}"
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        rc=false
      end
      rc
    end
  end


end