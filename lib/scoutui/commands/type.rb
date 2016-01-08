

module Scoutui::Commands

  class Type < Command


    def execute(drv=nil)
      @drv=drv if !drv.nil?
      _xpath = @cmd.match(/type\((.*),\s*/)[1].to_s
      _val   = @cmd.match(/type\(.*,\s*(.*)\)/)[1].to_s

      puts __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      obj = Scoutui::Base::QBrowser.getObject(@drv, _xpath)

      if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password|email)/).nil?
        obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
      else
        puts __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
      end

    end


  end



end
