require 'eyes_selenium'

module Scoutui::Eyes


  class EyeScout

    attr_accessor :drv
    attr_accessor :eyes

    def teardown()
      @drv.quit()
    end

    def navigate(url)
      @drv.navigate().to(url)
    end

    def drv()
      @drv
    end

    def eyes()
      @eyes
    end


    def closeOut()
      eyes().close(false)
      eyes().abort_if_not_closed if !eyes().nil?
    end

    def check_window(tag)
      puts __FILE__ + (__LINE__).to_s + " check_window(#{tag.to_s})"  if Scoutui::Utils::TestUtils.instance.isDebug?

      return if !Scoutui::Utils::TestUtils.instance.eyesEnabled?

      eyes().check_window(tag.to_s)
    end

    def initialize(browserType)
      browserType = Scoutui::Base::UserVars.instance.getBrowserType()

      if Scoutui::Utils::TestUtils.instance.isDebug?
        puts __FILE__ + (__LINE__).to_s + " setup() : #{browserType}"
        puts __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        puts __FILE__ + (__LINE__).to_s + " title => " + Scoutui::Base::UserVars.instance.getVar('eyes.title')
        puts __FILE__ + (__LINE__).to_s + " app => " + Scoutui::Base::UserVars.instance.getVar('eyes.app')
        puts __FILE__ + (__LINE__).to_s + " match_level => " + Scoutui::Base::UserVars.instance.getVar('eyes.match_level')
      end

      begin
        @drv=Selenium::WebDriver.for browserType.to_sym
        @eyes=Scoutui::Eyes::EyeFactory.instance.createEyes()

        puts __FILE__ + (__LINE__).to_s + " eyes => #{eyes}" if Scoutui::Utils::TestUtils.instance.isDebug?

        @driver = @eyes.open(
            app_name:  Scoutui::Base::UserVars.instance.getVar('eyes.app'),   # @eyesRecord['app'],
            test_name: Scoutui::Base::UserVars.instance.getVar('eyes.title'), # @eyesRecord['title'],
            viewport_size: {width: 1024, height: 768},
            #    viewport_size: {width: 800, height: 600},
            driver: @drv)

      rescue => ex
        puts ex.backtrace
      end

    end


  end




end