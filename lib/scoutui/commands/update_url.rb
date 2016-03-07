module Scoutui::Commands

  class UpdateUrl < Command


    def execute(drv)
      @drv=drv if !drv.nil?

      _req = Scoutui::Utils::TestUtils.instance.getReq()

      baseUrl = Scoutui::Base::UserVars.instance.getHost()

      url = @cmd.match(/navigate\s*\((.*)\)/)[1].to_s.strip
      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " url => #{url}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      _relativeUrl = url.strip.start_with?('/')


      if _relativeUrl
        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " [relative url]: #{baseUrl} with #{url}"  if Scoutui::Utils::TestUtils.instance.isDebug?
        url = baseUrl + url
      end

      url = Scoutui::Base::UserVars.instance.get(url)

      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " | translate : #{url}" if Scoutui::Utils::TestUtils.instance.isDebug?

      _rc=false
      begin
        @drv.navigate.to(url)
        _rc=true
      rescue
        ;
      end


      setResult(_rc)

    end

  end



end