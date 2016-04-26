module Scoutui::Actions
  class Pause < BaseAction

    def initialize(driver)
      super(driver)
    end

    def up
      gets
    end

    def inspect
      puts "====== PAUSED - ENTER TO CONTINUE =========".yellow
    end
  end
end

