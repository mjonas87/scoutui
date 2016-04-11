

module Scoutui::Base


  class TestScout
    attr_reader :context
    attr_reader :test_settings  # { host, dut }
    attr_reader :userRecord
    attr_reader :eyesRecord   # {'title' , 'app'}
    attr_reader :eye_scout
    attr_reader :results

    def initialize(_context)
      @result = nil
      @test_settings=nil
      @eyesRecord=nil

      if Scoutui::Utils::TestUtils.instance.hasTestConfig?
        @test_settings = Scoutui::Utils::TestUtils.instance.getTestSettings
        @eyesRecord = @test_settings['eyes']
      end
    end


    def start
      if has_settings?
        dump_settings if Scoutui::Utils::TestUtils.instance.isDebug?
        run
      end
    end

    def stop
      # TBD
    end

    def report
      @eye_scout.generateReport
    end

    def has_settings?
      Scoutui::Utils::TestUtils.instance.hasTestConfig?
    end

    def dump_settings
      Scoutui::Logger::LogMgr.instance.debug '-' * 72
      Scoutui::Logger::LogMgr.instance.debug @test_settings

      Scoutui::Logger::LogMgr.instance.debug "UserRecord => #{@userRecord}"
      Scoutui::Logger::LogMgr.instance.debug "Eyes Record => #{@eyesRecord}"
      Scoutui::Logger::LogMgr.instance.debug "Host => #{@test_settings['host']}"
    end

  def teardown
    @eye_scout.teardown
  end

    def setup

      if Scoutui::Utils::TestUtils.instance.isDebug?
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " title => " + Scoutui::Base::UserVars.instance.getVar('eyes.title')
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " app => " + Scoutui::Base::UserVars.instance.getVar('eyes.app')
      end

      begin
        eye_scout = Scoutui::Eyes::EyeFactory.instance.createScout
      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug ex.backtrace
      end

      eye_scout
    end


    def snap_page(tag)
      @eye_scout.check_window(tag)
    end


    def run
      Scoutui::Logger::LogMgr.instance.info 'Beginning Test...'

      begin
        @eye_scout = setup    # Browser is created

        @eye_scout.navigate(Scoutui::Base::UserVars.instance.get(:host))

        snap_page('Landing Page')

        Scoutui::Base::VisualTestFramework.processFile(@eye_scout, @test_settings)
        teardown
      rescue => ex
        Scoutui::Logger::LogMgr.instance.debug ex.backtrace
      ensure
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__ ).to_s + " Close Eyes" if Scoutui::Utils::TestUtils.instance.isDebug?
        @eye_scout.closeOut
      end
    end
  end


end
