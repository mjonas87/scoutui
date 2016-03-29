#require 'eyes_selenium'
#require 'testmgr'

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


    #---- 5150 -----
    def get_session_id(url)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " -- get_session_id(#{url}) =="
      _s=/sessions\/(?<session>\d+)/.match(url)[1]

    end

    def get_diff_urls(session_id, view_key)
      info = "https://eyes.applitools.com/api/sessions/#{session_id}/?ApiKey=#{view_key}&format=json"
      diff_template = "https://eyes.applitools.com/api/sessions/#{session_id}/steps/%s/diff?ApiKey=#{view_key}"
      diff_urls = Hash.new

      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " info => #{info}"
      response = HTTParty.get(info)

      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " RESP => #{response.to_s}"

      begin
        data = JSON.parse(response.body)
        index = 1
        data['actualOutput'].each do |elem|
          if !elem.nil? && (elem['isMatching'] == false)
            #diff_urls[index] = diff_template % [index]
            Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " #{index.to_s} :#{elem['tag'].to_s}"
            #diff_urls[index] = diff_template % [index]
            diff_urls[index] = { :tag => elem['tag'].to_s, :url => diff_template % [index] }
            index+=1
          end
        end

        diff_urls

      rescue JSON::ParserError
        ;
      end

    end

    def sanitize_filename(filename)
      # Split the name when finding a period which is preceded by some
      # character, and is followed by some character other than a period,
      # if there is no following period that is followed by something
      # other than a period
      fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

      # We now have one or two parts (depending on whether we could find
      # a suitable period). For each of these parts, replace any unwanted
      # sequence of characters with an underscore
      fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

      # Finally, join the parts with a period and return the result
      return fn.join '.'
    end

    def download_images(diff_urls, destination)
      diff_urls.each do |index, elem|
        save_name = sanitize_filename(elem[:tag]) + ".step_#{index}_diff.png"
        File.open("#{destination}/#{save_name}", 'wb') do |file|
          file.write HTTParty.get(elem[:url])
        end
      end
    end

    def saveDiffs(_eyes, results, outdir, view_key)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s +  "  saveDiffs(#{outdir.to_s})"

      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " | steps : #{results.steps.to_s}"
      session_id = get_session_id(results.url)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " session => #{session_id}"

      diffs = get_diff_urls(session_id, view_key)

      diffs.each do |d|
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " #{d.to_s}"
      end

      download_images(diffs, outdir)

    end
    #---- END 5150


    def closeOut()

#      Scoutui::Base::QHarMgr.instance.stop('/tmp/scoutui.har')

      return if !Scoutui::Utils::TestUtils.instance.eyesEnabled?
      @testResults = eyes().close(false)

      Testmgr::TestReport.instance.getReq("EYES").testcase('Images').add(@testResults.steps.to_i > 0, "Verify at least 1 shot taken (#{@testResults.steps.to_s} shots)")
      Testmgr::TestReport.instance.getReq("EYES").testcase('Images').add(@testResults.missing.to_i==0, "Verify Eyes did not miss any screens (#{@testResults.missing.to_s} screens)")

      # 5150
      _diffdir=Scoutui::Utils::TestUtils.instance.getDiffDir()
      if ENV.has_key?('APPLITOOLS_VIEW_KEY') && !_diffdir.nil?

        if Dir.exists?(_diffdir)
          saveDiffs(eyes(), @testResults, _diffdir, ENV['APPLITOOLS_VIEW_KEY'])
        else
          Scoutui::Logger::LogMgr.instance.warn " Specified Visual Diff folder does not exist - #{_diffdir.to_s}.  Unable to download diffs"
        end

      else
        Scoutui::Logger::LogMgr.instance.info " Unable to download diff images - APPLITOOLS_VIEW_KEY not defined"
      end


      eyes().abort_if_not_closed if !eyes().nil?
    end

    def check_window(tag, region=nil)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " check_window(#{tag.to_s})"  if Scoutui::Utils::TestUtils.instance.isDebug?

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

      if Scoutui::Utils::TestUtils.instance.eyesEnabled?
        Scoutui::Logger::LogMgr.instance.debug " testResults.methods = #{@testResults.methods.sort.to_s}"
        Scoutui::Logger::LogMgr.instance.info " Eyes.TestResults.Missing    : #{@testResults.missing.to_s}"
        Scoutui::Logger::LogMgr.instance.info " Eyes.TestResults.Matches    : #{@testResults.matches.to_s}"
        Scoutui::Logger::LogMgr.instance.info " Eyes.TestResults.Mismatches : #{@testResults.mismatches.to_s}"
        Scoutui::Logger::LogMgr.instance.info " Eyes.TestResults.Passed     : #{@testResults.passed?.to_s}"
        Scoutui::Logger::LogMgr.instance.info " Eyes.TestResults.Steps      : #{@testResults.steps.to_s}"
      end

      Scoutui::Logger::LogMgr.instance.info " TestReport => #{@testResults}"

      Testmgr::TestReport.instance.report()

#     Testmgr::TestReport.instance.generateReport()

      metrics=Testmgr::TestReport.instance.getMetrics()
      Scoutui::Logger::LogMgr.instance.info "Metrics => #{metrics}"

      Scoutui::Utils::TestUtils.instance.setMetrics(metrics)
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
      Testmgr::TestReport.instance.addRequirement('Command')
      Testmgr::TestReport.instance.getReq('Command').add(Testmgr::TestCase.new('isValid', "isValid"))

      Testmgr::TestReport.instance.getReq('UI').add(Testmgr::TestCase.new('expectJsAlert', 'expectJsAlert'))

      if Scoutui::Utils::TestUtils.instance.isDebug?
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " setup() : #{browserType}"
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " sauce    => " + Scoutui::Utils::TestUtils.instance.eyesEnabled?.to_s
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " viewport => #{viewport_size}"
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " eyes cfg => #{@eyesRecord}"
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " title => " + Scoutui::Base::UserVars.instance.getVar('eyes.title')
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " app => " + Scoutui::Base::UserVars.instance.getVar('eyes.app')
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " match_level => " + Scoutui::Base::UserVars.instance.getVar('eyes.match_level')
      end

      begin

#        Scoutui::Base::QHarMgr.instance.start()
#        @profile.proxy = Scoutui::Base::QHarMgr.instance.getSeleniumProfile()

        @strategy = Scoutui::Commands::Strategy.new()

        @eyes=Scoutui::Eyes::EyeFactory.instance.createEyes()

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " eyes => #{eyes}" if Scoutui::Utils::TestUtils.instance.isDebug?

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
        Scoutui::Logger::LogMgr.instance.info ex.backtrace
      end

    end


  end




end