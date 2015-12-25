require_relative './commands'

module Scoutui::Commands

  class ClickObject < Command


    def execute(drv)
      @drv=drv if !drv.nil?

      _xpath = @cmd.match(/click\s*\((.*)\)/)[1].to_s.strip
      puts __FILE__ + (__LINE__).to_s + " clickObject => #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      _xpath = Scoutui::Base::UserVars.instance.get(_xpath)

      puts __FILE__ + (__LINE__).to_s + " | translate : #{_xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?

      obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)
      obj.click if obj
    end

  end



end
