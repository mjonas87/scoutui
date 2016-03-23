require 'testmgr'
require 'sauce_whisk'

module Scoutui::Commands

  class Strategy

    attr_accessor :drv
    attr_accessor :profile

    def getDriver()
      @drv
    end

    def loadModel(f)
      rc=true
      begin
        rc=Scoutui::Utils::TestUtils.instance.loadModel(f)
      rescue => ex
        rc=false
      end

      rc
    end

    def navigate(url)
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " [enter]:navigate(#{url})"
      rc = false
      begin
        processCommand('navigate(' + url + ')', nil)
        rc=true
      rescue => ex
        Scoutui::Logger::LogMgr.instance.warn "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.warn "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      end

      rc
    end

    def report()
      Testmgr::TestReport.instance.report()
    end

    def quit()

      if Scoutui::Utils::TestUtils.instance.sauceEnabled?
        job_id = @drv.session_id
        SauceWhisk::Jobs.change_status job_id, true
      end

      @drv.quit()
    end

    def processCommands(cmds)
      Scoutui::Commands::processCommands(cmds, getDriver())
    end

    def processCommand(_action, e=nil)
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " [enter]:processCommand(#{_action})"
      Scoutui::Commands::processCommand(_action, e, getDriver())
    end

    def setup(dut)
      caps                      = Selenium::WebDriver::Remote::Capabilities.send(dut[:browserName])
      caps.version              = dut[:version]
      caps.platform             = dut[:platform]
      caps[:name]               = dut[:full_description]
      caps
    end

    def initialize()

      @profile=nil
      browserType = Scoutui::Base::UserVars.instance.getBrowserType()

      if false
        if !browserType.to_s.match(/chrome/i).nil?
          @profile = Selenium::WebDriver::Chrome::Profile.new
        elsif !browserType.to_s.match(/fire/i).nil?
          @profile = Selenium::WebDriver::Firefox::Profile.new
        elsif !browserType.to_s.match(/ie/i).nil?
          @profile = Selenium::WebDriver::IE::Profile.new
        elsif !browserType.to_s.match(/safari/i).nil?
          @profile = Selenium::WebDriver::Safari::Profile.new
        else
          @profile = Selenium::WebDriver::Firefox::Profile.new
          browserType='firefox'
        end

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " profile => #{@profile}"
      end

      if Scoutui::Utils::TestUtils.instance.sauceEnabled?

        caps = Scoutui::Utils::TestUtils.instance.getCapabilities()
        client=nil
        proxy=nil

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Capabilities => #{caps.to_s}"

        if caps.nil?

          caps = {
              :platform => "Mac OS X 10.9",
              :browserName => "chrome",
              :version => "31",
              :full_description => 'Rover Test'
          }

        elsif caps.has_key?(:platform) && caps[:platform].match(/os x/i)
          tmpCaps = caps

          if caps.has_key?(:deviceName) && caps[:deviceName].match(/iphone/i)
            caps = Selenium::WebDriver::Remote::Capabilities.iphone()
          elsif caps.has_key?(:browser) && caps[:browser].match(/chrome/i)
            caps = Selenium::WebDriver::Remote::Capabilities.chrome()
          elsif caps.has_key?(:browser) && caps[:browser].match(/firefox/i)
            caps = Selenium::WebDriver::Remote::Capabilities.firefox()
          elsif caps.has_key?(:browser) && caps[:browser].match(/safari/i)
            caps = Selenium::WebDriver::Remote::Capabilities.safari()
          end

          tmpCaps.each_pair do |k, v|
            caps[k.to_s]=v
          end


        elsif caps.has_key?(:platform) && caps[:platform].match(/windows/i)
          tmpCaps = caps

          if caps.has_key?(:browser) && caps[:browser].match(/edge/i)
            caps = Selenium::WebDriver::Remote::Capabilities.edge()
          elsif caps.has_key?(:browser) && caps[:browser].match(/chrome/i)
            caps = Selenium::WebDriver::Remote::Capabilities.chrome()
          elsif caps.has_key?(:browser) && caps[:browser].match(/firefox/i)
            caps = Selenium::WebDriver::Remote::Capabilities.firefox()
          else
            caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer()
          end

          tmpCaps.each_pair do |k, v|
            caps[k.to_s]=v
          end

        elsif caps.has_key?(:deviceName) && caps[:deviceName].match(/(iphone|ipad)/i) && !caps[:deviceName].match(/simulator/i)
          caps = Selenium::WebDriver::Remote::Capabilities.iphone()
          caps['platform'] = 'OS X 10.10'
          caps['version'] = '9.1'
          caps['deviceName'] = 'iPhone 6 Plus'
          caps['deviceOrientation'] = 'portrait'

          if caps['deviceName'].match(/iphone/i)
            client = Selenium::WebDriver::Remote::Http::Default.new
            client.timeout = 360 # seconds – default is 60
          end

        elsif caps.has_key?(:deviceName) && caps[:deviceName].match(/(iphone|ipad)/i) && caps[:deviceName].match(/simulator/i)

          proxyVal = "localhost:8080"

          proxy = Selenium::WebDriver::Proxy.new(
              :http     => proxyVal,
              :ftp      => proxyVal,
              :ssl      => proxyVal
          )

          tmpCaps = caps

          caps = Selenium::WebDriver::Remote::Capabilities.iphone(:proxy => proxy)

          tmpCaps.each_pair do |k, v|
            caps[k.to_s]=v
          end

          client = Selenium::WebDriver::Remote::Http::Default.new
          client.timeout = 360 # seconds – default is 60

        end

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Capabilities => #{caps.to_s}"

        sauce_endpoint = "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub"

        caps[:name]=Scoutui::Utils::TestUtils.instance.getSauceName()
        caps[:tags]=["Concur QE", "ScoutUI"]

        begin
          if client.nil?
            @drv=Selenium::WebDriver.for :remote, :url => sauce_endpoint, :desired_capabilities => caps # setup(caps)
          else
            @drv=Selenium::WebDriver.for :remote, :url => sauce_endpoint, :http_client => client, :desired_capabilities => caps # setup(caps)
          end

        rescue => e
          Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{$!}"
          Scoutui::Logger::LogMgr.instance.debug "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
        end


      else
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Create WebDriver: #{browserType.to_s}"
        @drv=Selenium::WebDriver.for browserType.to_sym, :profile => @profile
      end

    end

  end


end
