require 'json'

module Scoutui::Base


  class TestSettings

    attr_accessor :bEyes
    attr_accessor :browserType
    attr_accessor :eut
    attr_accessor :user
    attr_accessor :eyesReport
    attr_accessor :url


    def initialize(opts)
      @bEyes=false
      @browserType=opts[:but] || :firefox
      @eut=opts[:eut] || :qa
      @lang=opts[:lang] || "en-us"
      @user=opts[:user] || nil
      @eyesReport=opts[:eyesReport] || nil
      @url=opts[:url]||nil

    end

    def setConfig(c)
      if c.instance_of?(Hash)
        @testConfig=c
      else
        # a JSON file was passed  (ERROR handling needed)
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


