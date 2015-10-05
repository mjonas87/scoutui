

module Scoutui::Base


  class TestScout
    attr_reader :context
    attr_reader :test_settings  # { host, localization, dut }
    attr_reader :userRecord
    attr_reader :eyesRecord   # {'title' , 'app'}
    attr_reader :eyeScout
    attr_reader :results

    def initialize(_context)
      @result = nil
      @test_settings=nil
      @eyesRecord=nil

      if Scoutui::Utils::TestUtils.instance.hasTestConfig?

        puts __FILE__ + (__LINE__).to_s +  " * test config json => " + Scoutui::Utils::TestUtils.instance.testConfigFile() if Scoutui::Utils::TestUtils.instance.isDebug?

        @test_settings=Scoutui::Utils::TestUtils.instance.getTestSettings()

   #     accounts = Scoutui::Base::QAccounts.new(Scoutui::Base::UserVars.instance.getVar(:accounts))

   #     @userRecord = accounts.getUserRecord(@test_settings['user'])

        @eyesRecord = @test_settings['eyes']
      end

    end


    def start
      if hasSettings?
        dumpSettings if Scoutui::Utils::TestUtils.instance.isDebug?
        run()
      end
    end

    def stop
      # TBD
    end

    def report

    end

    def hasSettings?
      Scoutui::Utils::TestUtils.instance.hasTestConfig?
    end

    def dumpSettings()
      puts '-' * 72
      puts @test_settings

      puts "UserRecord => #{@userRecord}"
      puts "Eyes Record => #{@eyesRecord}"
      puts "Host => #{@test_settings['host']}"
    end

  def teardown()
    @eyeScout.teardown()
  end

    def setup()

      if Scoutui::Utils::TestUtils.instance.isDebug?
        puts __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        puts __FILE__ + (__LINE__).to_s + " title => " + Scoutui::Base::UserVars.instance.getVar('eyes.title')
        puts __FILE__ + (__LINE__).to_s + " app => " + Scoutui::Base::UserVars.instance.getVar('eyes.app')
      end

      begin

        eyeScout=Scoutui::Eyes::EyeFactory.instance.createScout()
      rescue => ex
        puts ex.backtrace
      end

      eyeScout
    end



    def goto(url=nil)
      @eyeScout.navigate(url) if !url.nil?
    end

    def snapPage(tag)
      @eyeScout.check_window(tag)
    end


    def run()
      puts __FILE__ + (__LINE__).to_s + " run()" if Scoutui::Utils::TestUtils.instance.isDebug?

      begin

        @eyeScout=setup()    # Browser is created

        # Navigate to the specified host
        goto(Scoutui::Base::UserVars.instance.get(:host))

        snapPage('Landing Page')

        Scoutui::Base::VisualTestFramework.processFile(@eyeScout, @test_settings)

        teardown()

      rescue => ex
        puts ex.backtrace
      ensure
        puts __FILE__ + (__LINE__ ).to_s + " Close Eyes" if Scoutui::Utils::TestUtils.instance.isDebug?
        @eyeScout.closeOut()
      end

    end



  end


end
