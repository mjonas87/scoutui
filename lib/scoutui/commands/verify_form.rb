
require_relative './commands'

module Scoutui::Commands


  class VerifyForm < Command


    def execute(drv)
      @drv=drv if !drv.nil?

      _form = @cmd.match(/verifyform\((.*)\s*\)/)[1].to_s

      puts __FILE__ + (__LINE__).to_s + " form : #{_form}"

      _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
      _f.dump()
      _f.verifyForm(@drv)

    end

  end


end