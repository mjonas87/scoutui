

module Scoutui::Commands

  class Pause < Command

    def execute(e=nil)
      rc=true
      h=""
      begin
        if e.is_a?(Hash) && e.has_key?('page')
          h=e['page']['name'].to_s
        end
        puts "====== PAUSE - HIT ENTER #{h} ========="
        gets()
      rescue => ex
        puts "Error during processing: #{$!}"
        puts "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
        rc=false
      end
      setResult(rc)
    end
  end


end