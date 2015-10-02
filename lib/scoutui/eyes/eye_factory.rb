
require 'singleton'


module Scoutui::Eyes


  class EyeFactory
    include Singleton

    attr_accessor :eyesList

    def initialize
      @eyesList=Array.new()
    end

    def createScout()
      browserType = Scoutui::Base::UserVars.instance.getBrowserType()
      eyeScout = EyeScout.new(browserType)
    end

    def createEyes()

      use_eyes = Scoutui::Utils::TestUtils.instance.eyesEnabled?

      puts __FILE__ + (__LINE__).to_s + " create(#{use_eyes})" if Scoutui::Utils::TestUtils.instance.isDebug?
      eyes=nil

      if use_eyes

        licFile=Scoutui::Utils::TestUtils.instance.getLicenseFile()

        valid_json=false
        begin
          jFile = File.read(licFile)
          jLicense=jsonData=JSON.parse(jFile)
          valid_json=true
        rescue => ex
          ;
        end


        if valid_json
          eyes=Applitools::Eyes.new()
          eyes.api_key = jLicense['api_key'].to_s
          eyes.force_fullpage_screenshot = true

          match_level = Scoutui::Base::UserVars.instance.getVar('eyes.match_level')

          eyes.match_level = Applitools::Eyes::MATCH_LEVEL[match_level.to_sym]
        end

      end

    #  eyes
      @eyesList << eyes
      @eyesList.last()
    end

  end



end
