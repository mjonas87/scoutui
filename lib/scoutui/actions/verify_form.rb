
require_relative './actions'

module Scoutui::Actions


  class VerifyForm < Action


    def execute(drv)
      @drv=drv if !drv.nil?

      _form = @cmd.match(/verifyform\((.*)\s*\)/)[1].to_s

      Scoutui::Logger::LogMgr.instance.debug  __FILE__ + (__LINE__).to_s + " VerifyForm.execute : #{_form}"

      _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
      _f.dump()
      _f.verifyForm(@drv)

    end

  end


end
