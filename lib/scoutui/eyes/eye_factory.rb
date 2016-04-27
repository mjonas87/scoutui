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
      user_vars = Scoutui::Base::UserVars.instance
      browserType = user_vars.getBrowserType()
      eyeScout = EyeScout.new(browserType)
    end

    def createEyes()
      use_eyes = Scoutui::Utils::TestUtils.instance.eyesEnabled?
      eyes = nil

      if use_eyes
        license_key = nil
        licFile = Scoutui::Utils::TestUtils.instance.getLicenseFile()
        if !licFile.empty?
          valid_json = false
          begin
            jFile = File.read(licFile)
            jLicense = jsonData = JSON.parse(jFile)
            license_key = jLicense['api_key'].to_s
            valid_json = true
          rescue => ex
            ;
          end
        elsif ENV.has_key?('APPLITOOLS_API_KEY')
          license_key = ENV['APPLITOOLS_API_KEY'].to_s
        end

        if !license_key.nil?
          eyes = Applitools::Eyes.new()
          eyes.api_key = license_key
          eyes.force_fullpage_screenshot = true

          user_vars = Scoutui::Base::UserVars.instance
          match_level = user_vars.getVar('eyes.match_level')

          eyes.match_level = Applitools::Eyes::MATCH_LEVEL[match_level.to_sym]
        end

        ## TBD - eyes.open()
      end

      Scoutui::Logger::LogMgr.instance.info 'Using Applitools'.blue unless eyes.nil?
      Scoutui::Logger::LogMgr.instance.info 'Not using Applitools'.red if eyes.nil?

      @eyesList << eyes
      @eyesList.last
    end
  end
end
