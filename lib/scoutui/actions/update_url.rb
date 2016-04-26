module Scoutui::Actions

  class UpdateUrl < Action


    def execute(drv)
      @drv = drv if !drv.nil?
      _req = Scoutui::Utils::TestUtils.instance.getReq()
      baseUrl = Scoutui::Base::UserVars.instance.getHost()

      url = @cmd.match(/navigate\s*\((.*)\)/i)[1].to_s.strip
      _relativeUrl = url.strip.start_with?('/')

      if _relativeUrl
        url = baseUrl + url
      end

      url = Scoutui::Base::UserVars.instance.get(url)

      _rc = false
      begin
        @drv.navigate.to(url)
        _rc = true
      end

      setResult(_rc)

    end

  end



end
