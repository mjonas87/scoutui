
module Scoutui::Commands

  class MouseOver < Command

    def execute(drv=nil)

      @drv=drv if !drv.nil?

      _xpath = @cmd.match(/mouseover\s*\((.*)\)/)[1].to_s.strip
      obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)
      @drv.action.move_to(obj).perform
    end



  end


end
