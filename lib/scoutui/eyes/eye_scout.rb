require 'eyes_selenium'
require 'testmgr'

module Scoutui::Eyes


  class EyeScout

    attr_accessor :eyes
    attr_accessor :testResults
    attr_accessor :strategy

    def teardown()
      @strategy.quit()
    end

    def navigate(url)
    @strategy.navigate(url)
    end

    def drv()
      @strategy.getDriver()
    end

    def getStrategy()
      @strategy
    end

    def eyes()
      @eyes
    end


    def closeOut()

#      Scoutui::Base::QHarMgr.instance.stop('/tmp/scoutui.har')

      return if !Scoutui::Utils::TestUtils.instance.eyesEnabled?
      @testResults = eyes().close(false)
      eyes().abort_if_not_closed if !eyes().nil?
    end

    def check_window(tag, region=nil)
      puts __FILE__ + (__LINE__).to_s + " check_window(#{tag.to_s})"  if Scoutui::Utils::TestUtils.instance.isDebug?

      return if !Scoutui::Utils::TestUtils.instance.eyesEnabled?

      if region.nil?
        eyes().check_window(tag.to_s)
      else
        f = eyes().force_fullpage_screenshot
        eyes().check_region(:xpath, region, tag)
        eyes().force_fullpage_screenshot = f
      end

    end

    def generateReport()
      puts " TestReport => #{@testResults}"
   #  Testmgr::TestReport.instance.generateReport()
      Testmgr::TestReport.instance.report()
    end

    def getResults()
      @testResults
    end




    def initialize(browserType)
      @testResults=nil

      browserType = Scoutui::Base::UserVars.instance.getBrowserType()
      viewport_size = Scoutui::Base::UserVars.instance.getViewPort()

      Testmgr::TestReport.instance.setDescription('ScoutUI Test')
      Testmgr::TestReport.instance.setEnvironment(:qa, Scoutui::Utils::TestUtils.instance.getHost())
      Testmgr::TestReport.instance.addRequirement('UI')
      Testmgr::TestReport.instance.getReq('UI').add(Testmgr::TestCase.new('visible_when', "visible_when"))

      if Scoutui::Utils::TestUtils.instance.isDebug?
        puts __FILE__ + (__LINE__).to_s + " setup() : #{browserType}"
        puts __FILE__ + (__LINE__).to_s + " sauce    => " + Scoutui::Utils::TestUtils.instance.eyesEnabled?.to_s
        puts __FILE__ + (__LINE__).to_s + " viewport => #{viewport_size}"
        puts __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        puts __FILE__ + (__LINE__).to_s + " title => " + Scoutui::Base::UserVars.instance.getVar('eyes.title')
        puts __FILE__ + (__LINE__).to_s + " app => " + Scoutui::Base::UserVars.instance.getVar('eyes.app')
        puts __FILE__ + (__LINE__).to_s + " match_level => " + Scoutui::Base::UserVars.instance.getVar('eyes.match_level')
      end

      begin

#        Scoutui::Base::QHarMgr.instance.start()
#        @profile.proxy = Scoutui::Base::QHarMgr.instance.getSeleniumProfile()

        @strategy = Scoutui::Commands::Strategy.new()

        @eyes=Scoutui::Eyes::EyeFactory.instance.createEyes()

        puts __FILE__ + (__LINE__).to_s + " eyes => #{eyes}" if Scoutui::Utils::TestUtils.instance.isDebug?

        ## TBD - move the following into eye_scout ??
        if Scoutui::Utils::TestUtils.instance.eyesEnabled?
          @driver = @eyes.open(
              app_name:  Scoutui::Base::UserVars.instance.getVar('eyes.app'),   # @eyesRecord['app'],
              test_name: Scoutui::Base::UserVars.instance.getVar('eyes.title'), # @eyesRecord['title'],
              viewport_size: viewport_size,
              #    viewport_size: {width: 800, height: 600},
              driver: @strategy.getDriver())
        end

      rescue => ex
        puts ex.backtrace
      end

    end


  end




end