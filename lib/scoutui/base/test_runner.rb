

module Scoutui::Base


  class TestRunner
    attr_reader :drv    # Selenium Webdriver
    attr_reader :eyes   # Applitools::Eyes
    attr_reader :driver  # Applitools::Eyes Driver
    attr_reader :context
    attr_reader :test_settings  # { host, localization, dut }
    attr_reader :userRecord
    attr_reader :eyesRecord   # {'title' , 'app'}

    def initialize(_context)

      @test_settings=nil
      @eyesRecord=nil

      if Scoutui::Utils::TestUtils.instance.hasTestConfig?

        puts __FILE__ + (__LINE__).to_s +  " * test config json => " + Scoutui::Utils::TestUtils.instance.testConfigFile() if Scoutui::Utils::TestUtils.instance.isDebug?

        @test_settings=Scoutui::Utils::TestUtils.instance.getTestSettings()

        accounts = Scoutui::Base::QAccounts.new()
        @userRecord = accounts.getUserRecord(@test_settings['user'])

        @eyesRecord = @test_settings['eyes']

      end

    end



    def hasSettings?
      Scoutui::Utils::TestUtils.instance.hasTestConfig?
    end

    def dumpSettings()
      puts __FILE__ + (__LINE__).to_s + " dumpSettings()"
      puts '-' * 72
      puts @test_settings

      puts "UserRecord => #{@userRecord}"
      puts "Eyes Record => #{@eyesRecord}"
      puts "Host => #{@test_settings['host']}"
    end

  def teardown()
    @drv.quit()
  end

    def setup()
      browserType = Scoutui::Utils::TestUtils.instance.getBrowserType()
      puts __FILE__ + (__LINE__).to_s + " setup() : #{browserType}"

      begin
        @drv=Selenium::WebDriver.for browserType.to_sym
        @eyes=Scoutui::Eyes::EyeFactory.instance.create(true)
        puts __FILE__ + (__LINE__).to_s + " eyes => #{eyes}"

        @driver = @eyes.open(
            app_name: @eyesRecord['app'],
            test_name: @eyesRecord['title'],
            viewport_size: {width: 1024, height: 768},
            #    viewport_size: {width: 800, height: 600},
            driver: @drv)

      rescue => ex
        puts ex.backtrace
      end
      @drv
    end



    def goto(url)
      @drv.navigate().to(url)
    end

    def snapPage(tag)
      @eyes.check_window(tag)  if Scoutui::Utils::TestUtils.instance.eyesEnabled?
    end


    def run()
      puts __FILE__ + (__LINE__).to_s + " run()" if Scoutui::Utils::TestUtils.instance.isDebug?

      my_driver=nil

      begin

        app = Scoutui::Base::AppModel.new()

        setup()    # Browser is created

        # Navigate to the specified host
        goto(Scoutui::Base::UserVars.instance.get(:host))

        snapPage('Landing Page')

        Scoutui::Base::VisualTestFramework.processFile(@drv, @eyes, @test_settings)

        teardown()

      rescue => ex
        puts ex.backtrace
      ensure
        puts __FILE__ + (__LINE__ ).to_s + " Close Eyes"
        eyes.close(false)
        eyes.abort_if_not_closed if !eyes.nil?
      end

    end



  end


end
