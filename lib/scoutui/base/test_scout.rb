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

      if Scoutui::Utils::TestUtils.instance.isDebug?
        # user_vars = Scoutui::Base::UserVars.new
        # Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        # Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " title => " + user_vars.getVar('eyes.title')
        # Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " app => " + user_vars.getVar('eyes.app')
      end

      @eye_scout = Scoutui::Eyes::EyeFactory.instance.createScout
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
      # Scoutui::Logger::LogMgr.instance.debug '-' * 72
      # Scoutui::Logger::LogMgr.instance.debug @test_settings
      # Scoutui::Logger::LogMgr.instance.debug "UserRecord => #{@userRecord}"
      # Scoutui::Logger::LogMgr.instance.debug "Eyes Record => #{@eyesRecord}"
      # Scoutui::Logger::LogMgr.instance.debug "Host => #{@test_settings['host']}"
    end

    def teardown
      @eye_scout.teardown
    end

    def snap_page(tag)
      @eye_scout.check_window(tag)
    end

    def run
      Scoutui::Logger::LogMgr.instance.info 'Beginning Test...'.blue

      begin
        @eye_scout.navigate(user_vars.get(:host))
        snap_page('Landing Page')

        Scoutui::Base::VisualTestFramework.processFile(@eye_scout, @test_settings)
        teardown
      ensure
        @eye_scout.closeOut unless @eye_scout.nil?
      end
    end
  end
end
