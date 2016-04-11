require 'eyes_selenium'
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
      puts "XXXXXXXXXXXXX: #{use_eyes}"
      binding.pry

      Scoutui::Logger::LogMgr.instance.info  __FILE__ + (__LINE__).to_s + " create(#{use_eyes})" if Scoutui::Utils::TestUtils.instance.isDebug?
      eyes=nil

      if use_eyes
        license_key=nil
        licFile=Scoutui::Utils::TestUtils.instance.getLicenseFile()
        if !licFile.empty?
          valid_json=false
          begin
            jFile = File.read(licFile)
            jLicense=jsonData=JSON.parse(jFile)
            license_key=jLicense['api_key'].to_s
            valid_json=true
          rescue => ex
            ;
          end
        elsif ENV.has_key?('APPLITOOLS_API_KEY')
          license_key=ENV['APPLITOOLS_API_KEY'].to_s
        end


        binding.pry
        if !license_key.nil?
          eyes = Applitools::Eyes.new()
          eyes.api_key = license_key
          eyes.force_fullpage_screenshot = true

          match_level = Scoutui::Base::UserVars.instance.getVar('eyes.match_level')

          eyes.match_level = Applitools::Eyes::MATCH_LEVEL[match_level.to_sym]
        end

        ## TBD - eyes.open()
      end

      @eyesList << eyes
      binding.pry
      @eyesList.last
    end
  end
end
