

module Scoutui::Commands

  class SubmitForm < Command

    def execute(drv=nil)
      @drv=drv if !drv.nil?

      _form = _action.match(/submitform\((.*)\s*\)/)[1].to_s
      _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
      _f.submitForm(@drv)
    end


  end



end
