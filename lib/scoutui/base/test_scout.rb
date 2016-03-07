

module Scoutui::Base


  class TestScout
    attr_reader :context
    attr_reader :test_settings  # { host, dut }
    attr_reader :userRecord
    attr_reader :eyesRecord   # {'title' , 'app'}
    attr_reader :eyeScout
    attr_reader :results

    def initialize(_context)
      @result = nil
      @test_settings=nil
      @eyesRecord=nil

      if Scoutui::Utils::TestUtils.instance.hasTestConfig?

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s +  " * test config json => " + Scoutui::Utils::TestUtils.instance.testConfigFile() if Scoutui::Utils::TestUtils.instance.isDebug?

        @test_settings=Scoutui::Utils::TestUtils.instance.getTestSettings()

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
      @eyeScout.generateReport()
    end

    def hasSettings?
      Scoutui::Utils::TestUtils.instance.hasTestConfig?
    end

    def dumpSettings()
      Scoutui::Logger::LogMgr.instance.debug '-' * 72
      Scoutui::Logger::LogMgr.instance.debug @test_settings

      Scoutui::Logger::LogMgr.instance.debug "UserRecord => #{@userRecord}"
      Scoutui::Logger::LogMgr.instance.debug "Eyes Record => #{@eyesRecord}"
      Scoutui::Logger::LogMgr.instance.debug "Host => #{@test_settings['host']}"
    end

  def teardown()
    @eyeScout.teardown()
  end

    def setup()

      if Scoutui::Utils::TestUtils.instance.isDebug?
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " title => " + Scoutui::Base::UserVars.instance.getVar('eyes.title')
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " app => " + Scoutui::Base::UserVars.instance.getVar('eyes.app')
      end

      begin

        eyeScout=Scoutui::Eyes::EyeFactory.instance.createScout()
      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug ex.backtrace
      end

      eyeScout
    end


    def snapPage(tag)
      @eyeScout.check_window(tag)
    end


    def run()
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " run()" if Scoutui::Utils::TestUtils.instance.isDebug?

      begin

        @eyeScout = setup()    # Browser is created

        # Navigate to the specified host
        @eyeScout.navigate(Scoutui::Base::UserVars.instance.get(:host))

    #    snapPage('Landing Page')

        Scoutui::Base::VisualTestFramework.processFile(@eyeScout, @test_settings)

        teardown()

      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug ex.backtrace
      ensure
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__ ).to_s + " Close Eyes" if Scoutui::Utils::TestUtils.instance.isDebug?
        @eyeScout.closeOut()



      end

    end



  end


end
