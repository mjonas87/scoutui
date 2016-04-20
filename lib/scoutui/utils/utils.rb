
require 'singleton'
require 'pp'
require 'optparse'



module Scoutui::Utils


  class TestUtils
    include Singleton

    attr_accessor :options
    attr_accessor :app_model
    attr_accessor :currentTest

    attr_accessor :metrics
    attr_accessor :final_rc

    def initialize

      @final_rc=false
      @metrics=nil

      @env_list={:accounts => 'SCOUTUI_ACCOUNTS', :browser => 'SCOUTUI_BROWSER', :applitools_api_key => 'APPLITOOLS_API_KEY'}
      @options={}
      @currentTest={:reqid => 'UI', :testcase => '00' }

      [:accounts, :browser, :capabilities, :diffs_dir, :test_file, :host, :loc, :title, :viewport,
       :userid, :password, :json_config_file, :page_model, :test_config, :debug].each do |o|
        @options[o]=nil
      end

      @options[:include_expected_as_asserts]=false
      @options[:role]=nil
      @options[:sauce_name]='unnamed'
      @options[:enable_eyes]=false
      @options[:enable_sauce]=false
      @options[:log_level]=:info     # :debug, :info, :warn, :error, :fatal
      @options[:match_level]='layout'
      @options[:debug]=false

      @app_model=nil

      Scoutui::Base::UserVars.instance.set('eyes.viewport', '1024x768')

    end

    def getFinalRc()
      @final_rc
    end

    def setFinalRc(b)
      @final_rc=b
    end

    def getMetrics()
      @metrics
    end

    def setMetrics(_m)
      @metrics=_m
    end

    def getReq()
      @currentTest[:reqid]
    end

    def setReq(_r='UI')
      @currentTest[:reqid]=_r
    end

    def loadModel(file_name = nil)
      return if file_name.nil?

      @app_model = Scoutui::ApplicationModel::QModel.new(file_name)
      @app_model.getAppModel()
      @app_model
    end


    def getForm(s)
      _h = getPageElement(s)
      Scoutui::Base::QForm.new(_h)
    end

    def getPageElement(selector)
      @app_model.get_page_node(selector)
    end

    def getAppModel()
      @app_model
    end

    def parseCommandLine()

      OptionParser.new do |opt|
        opt.on('-c', '--config TESTFILE') { |o|
            if !o.nil?
              @options[:json_config_file]=o

              jFile = File.read(@options[:json_config_file])
              @options[:test_config]=jsonData=JSON.parse(jFile)
            end
        }
        opt.on('--accounts [Account]')    { |o| @options[:accounts] = o }
        opt.on('-b', '--browser [TYPE]', [:chrome, :firefox, :ie, :safari, :phantomjs], "Select browser (chrome, ie, firefox, safari)") { |o| @options[:browser] = o }
        opt.on('--capabilities CAP') {  |o|
          @options[:capabilities]=o

          jFile = File.read(o)
          @options[:capabilities]=jsonData=JSON.parse(jFile, :symbolize_names => true)
        }

        opt.on('--loglevel Level') { |o|
          if o.match(/error/i)
            @options[:log_level] = :error
          elsif o.match(/fatal/i)
            @options[:log_level] = :fatal
          elsif o.match(/info/i)
            @options[:log_level] = :info
          elsif o.match(/warn/i)
            @options[:log_level] = :warn
          elsif o.match(/debug/i)
            @options[:log_level] = :debug
          end

          Scoutui::Logger::LogMgr.instance.setLevel(@options[:log_level])
        }

        opt.on('--diffs Full Path') { |o|
          @options[:diffs_dir] = o
        }

        opt.on('-d', '--debug', 'Enable debug')  { |o|
          @options[:debug] = true
          @options[:log_level] = :debug
        }
        opt.on('--dut DUT') { |o| @options[:dut]=o }
        opt.on('-h', '--host HOST')     { |o| @options[:host] = o }
        opt.on('-i', '--include_expectations') { |o| @options[:include_expected_as_asserts] = true}
        opt.on('-l', '--lang LOCAL')    { |o|
          @options[:loc] = o
          Scoutui::Base::UserVars.instance.setVar(:lang, @options[:loc].to_s)
        }
        opt.on('-k', '--key EyesLicense') { |o| options[:license_file] = o }
        opt.on('-a', '--app AppName')   { |o| @options[:app] = o }
        opt.on('--match [LEVEL]', [:layout2, :layout, :strict, :exact, :content], "Select match level (layout, strict, exact, content)") { |o| @options[:match_level] = o }

        opt.on("--pages a,b,c", Array, "List of page models") do |list|
          @options[:pages]=list
          loadModel(@options[:pages])
        end

        opt.on('--pagemodel [PageModel]') { |o|
          @options[:page_model] = o
          loadModel(@options[:page_model].to_s)
        }
        opt.on('-t', '--title TITLE')   { |o| @options[:title] = o }

        opt.on('-u', '--user USER_ID')  { |o|
          @options[:userid] = o
          Scoutui::Base::UserVars.instance.setVar(:user, @options[:userid].to_s)
        }
        opt.on('-p', '--password PASSWORD') { |o| @options[:password] = o }
        opt.on('-e', '--eyes', "Toggle eyes") {
          @options[:enable_eyes]=true
        }

        opt.on('--role ROLE') { |o| @options[:role]=o }

        opt.on('-s', '--sauce', "Toggle SauceLabs") {
          @options[:enable_sauce]=true
        }
        opt.on('--sauce_name NAME') { |o| @options[:sauce_name] = o }
        opt.on('--viewport [resolution]') { |o| options[:viewport] = o }
      end.parse!

      if Scoutui::Utils::TestUtils.instance.isDebug?
        # Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s +  "   " + @options.to_s
        # Scoutui::Logger::LogMgr.instance.info "Test file => #{@options[:test_file]}"
        # Scoutui::Logger::LogMgr.instance.info "Host      => #{@options[:host]}"
        # Scoutui::Logger::LogMgr.instance.info "Loc       => #{@options[:loc]}"
        # Scoutui::Logger::LogMgr.instance.info "Title     => #{@options[:title]}"
        # Scoutui::Logger::LogMgr.instance.info "Browser   => #{@options[:browser]}"
        # Scoutui::Logger::LogMgr.instance.info "UserID    => #{@options[:userid]}"
        # Scoutui::Logger::LogMgr.instance.info "Password  => #{@options[:password]}"
        # Scoutui::Logger::LogMgr.instance.info "Eyes      => #{@options[:enable_eyes]}"
        # Scoutui::Logger::LogMgr.instance.info "Test Cfg  => #{@options[:json_config_file]}"
        # Scoutui::Logger::LogMgr.instance.info "Match Level => #{@options[:match_level]}"
        # Scoutui::Logger::LogMgr.instance.info "Accounts    => #{@options[:accounts]}"
        # Scoutui::Logger::LogMgr.instance.info "Viewport    => #{@options[:viewport]}"
        # Scoutui::Logger::LogMgr.instance.info "Viewport (Var) => #{Scoutui::Base::UserVars.instance.getViewPort().to_s}"
        # Scoutui::Logger::LogMgr.instance.info "PageModel file => #{@options[:page_model].to_s}"
      end

      @options
    end

    def getCapabilities()
      @options[:capabilities]
    end

    def getHost()
      @options[:host].to_s
    end

    def setDebug(b)
      @options[:debug]=b
    end

    def isDebug?
      @options[:debug]
    end

    def eyesEnabled?
      @options[:enable_eyes]
    end

    def sauceEnabled?
      @options[:enable_sauce]
    end

    def getLicenseFile()
      @options[:license_file].to_s
    end

    def getRole()
      @options[:role]
    end

    def getSauceName()
      @options[:sauce_name].to_s
    end

    def getBrowser()
      getBrowserType()
    end
    def getBrowserType()
      @options[:browser]
    end

    def assertExpected?
      @options[:include_expected_as_asserts]
    end

    def hasTestConfig?
      !@options[:json_config_file].nil?
    end

    def testConfigFile()
      @options[:json_config_file]
    end

    # Returns JSON file contents/format
    def getTestSettings

      Scoutui::Logger::LogMgr.instance.setLevel(@options[:log_level])

      [:accounts, :browser, :dut, :host, :userid, :password].each do |k|

        if @options.has_key?(k) && !@options[k].nil?
          Scoutui::Base::UserVars.instance.set(k, @options[k].to_s)
        elsif @options[:test_config].has_key?(k.to_s)
          # Ensure commnand line takes precedence
          if !@options[k].nil?
            Scoutui::Base::UserVars.instance.set(k, @options[k].to_s)
          else
            Scoutui::Base::UserVars.instance.set(k, @options[:test_config][k.to_s].to_s)
          end

        elsif @env_list.has_key?(k)
          Scoutui::Base::UserVars.instance.set(k, ENV[@env_list[k].to_s])
        end
      end

      if @options[:test_config].has_key?('dut') && @options.has_key?(:dut)
        @options[:test_config]['dut']=@options[:dut]
      end

      # Applitools Eyes settings
      if @options[:test_config].has_key?('eyes')

        ['match_level', 'title', 'app', 'viewport'].each do |k|

          _v=nil

          if @options[:test_config]['eyes'].has_key?(k)
            _v=@options[:test_config]['eyes'][k].to_s
          end

          if !@options[k.to_sym].nil?
            _v=@options[k.to_sym].to_s
          end

          Scoutui::Base::UserVars.instance.set('eyes.' + k, _v) if !_v.nil?

        end
      end



      @options[:test_config]
    end


    def getTestConfig()
      @options[:test_config]
    end

    def match_level()
      @options[:match_level]
    end

    def getDiffDir()
      @options[:diffs_dir]
    end

    def getUserId()
      @options[:userid]
    end

    def getUser()
      getUserId()
    end

    def getPassword()
      @options[:password]
    end

    def testFile()
      @options[:test_file]
    end

    def host()
      @options[:host]
    end

    def loc()
      @options[:loc]
    end
    def localization()
      loc()
    end

    def appName()
      @options[:app].to_s
    end

    def title()
      @options[:title]
    end

  end








end
