require 'json'

module Scoutui::Base


  class TestSettings

    attr_accessor :bEyes
    attr_accessor :browserType
    attr_accessor :eut
    attr_accessor :user
    attr_accessor :eyesReport
    attr_accessor :url
    attr_accessor :localization


    def initialize(opts)
      @bEyes=false
      @browserType=opts[:but] || :firefox
      @eut=opts[:eut] || :qa
      @lang=opts[:lang] || "en-us"
      @user=opts[:user] || nil
      @eyesReport=opts[:eyesReport] || nil
      @url=opts[:url]||nil

      @localization_test_data='/Users/pkim/working/nui-qa/apps/gat/tests/localization.json'
      @localization_json = File.read(@localization_test_data)
      @localizationObj = JSON.parse(@localization_json)
    end

    def setConfig(c)
      if c.instance_of?(Hash)
        @testConfig=c
      else
        # a JSON file was passed
        jFile = File.read(c)
        @testConfig=JSON.parse(jFile)
      end

      @testConfig
    end


    def getScout()
      @testConfig["dut"]
    end

    def setLang(lang)
      @lang=lang
    end


    def getLocalization()
      #  @testConfig["language-mapping"][@lang]
      @localizationObj["language-mapping"][@lang]
    end

    def getUrl()
      @url
    end

    def url
      getUrl()
    end

    def setUrl(u)
      @url=u
    end

    def getEyesReport()
      @eyesReport
    end

    def getLanguage()
      getLang()
    end

    def getUser()
      @user
    end

    def getLang()
      @lang
    end

    def getBUT()
      @browserType
    end

    def setEUT(e)
      @eut=e
    end

    def getEUT()
      @eut
    end

    def browserType()
      @browserType
    end

    def enableEyes(b=true)
      @bEyes=b
    end

    def disableEyes()
      @bEyes=false
    end

    def isEyes?
      @bEyes
    end

  end


end


