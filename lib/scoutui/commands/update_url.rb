module Scoutui::Commands

  class UpdateUrl < Command


    def execute(drv)
      @drv=drv if !drv.nil?

      baseUrl = Scoutui::Base::UserVars.instance.getHost()

      url = @cmd.match(/navigate\s*\((.*)\)/)[1].to_s.strip
      puts __FILE__ + (__LINE__).to_s + " url => #{url}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      _relativeUrl = url.strip.start_with?('/')


      if _relativeUrl
        puts __FILE__ + (__LINE__).to_s + " [relative url]: #{baseUrl} with #{url}"  if Scoutui::Utils::TestUtils.instance.isDebug?
        url = baseUrl + url
      end

      url = Scoutui::Base::UserVars.instance.get(url)

      puts __FILE__ + (__LINE__).to_s + " | translate : #{url}" if Scoutui::Utils::TestUtils.instance.isDebug?

      @drv.navigate.to(url)

    end

  end



end