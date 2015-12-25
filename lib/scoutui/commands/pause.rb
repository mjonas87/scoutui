

module Scoutui::Commands

  class Pause < Command

    def execute(drv=nil)
      puts "====== PAUSE - HIT ENTER ========="
      gets()
    end
  end


end