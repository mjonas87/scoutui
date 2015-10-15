
require 'singleton'
require 'pp'
require 'optparse'


module Scoutui::Utils


  class TestUtils
    include Singleton

    attr_accessor :options
    attr_accessor :page_model

    def initialize

      @env_list={:accounts => 'SCOUTUI_ACCOUNTS', :browser => 'SCOUTUI_BROWSER', :applitools_api_key => 'APPLITOOLS_API_KEY'}
      @options={}

      [:accounts, :browser, :test_file, :host, :loc, :title, :viewport,
       :userid, :password, :json_config_file, :page_model, :test_config, :debug].each do |o|
        @options[o]=nil
      end

      @options[:enable_eyes]=false
      @options[:match_level]='layout'
      @options[:debug]=false

      @page_model=nil

      Scoutui::Base::UserVars.instance.set('eyes.viewport', '1024x768')

    end

    def loadPageModel()
      if !@options[:page_model].nil?
        _f = File.read(@options[:page_model].to_s)
        @page_model = JSON.parse(_f)

        puts __FILE__ + (__LINE__).to_s + " JSON-PageModel => #{@page_model}" if Scoutui::Utils::TestUtils.instance.isDebug?
      end
    end


    def getPageElement(s)
      hit=@page_model

      nodes = s.split(/\./)

      nodes.each { |elt|
        getter = elt.split(/\(/)[0]
        _obj = elt.match(/\((.*)\)/)[1]

        puts __FILE__ + (__LINE__).to_s + " getter : #{getter}  obj: #{_obj}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if getter.downcase=='page'
          puts __FILE__ + (__LINE__).to_s + " -- process page --"  if Scoutui::Utils::TestUtils.instance.isDebug?
          hit=@page_model[_obj]
        elsif getter.downcase=='get'
          hit=hit[_obj]
        end
        puts __FILE__ + (__LINE__).to_s + " HIT => #{hit}" if Scoutui::Utils::TestUtils.instance.isDebug?
      }

      hit

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
        opt.on('-d', '--debug', 'Enable debug')  { |o| @options[:debug] = true }
        opt.on('-h', '--host HOST')     { |o| @options[:host] = o }
        opt.on('-l', '--lang LOCAL')    { |o| @options[:loc] = o }
        opt.on('-k', '--key EyesLicense') { |o| options[:license_file] = o }
        opt.on('-a', '--app AppName')   { |o| @options[:app] = o }
        opt.on('--match [LEVEL]', [:layout2, :layout, :strict, :exact, :content], "Select match level (layout, strict, exact, content)") { |o| @options[:match_level] = o }

        opt.on('--pagemodel [PageModel]') { |o|
          @options[:page_model] = o
          loadPageModel()
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
        opt.on('--viewport [resolution]') { |o| options[:viewport] = o }
      end.parse!

      if Scoutui::Utils::TestUtils.instance.isDebug?
        puts __FILE__ + (__LINE__).to_s +  "   " + @options.to_s
        puts "Test file => #{@options[:test_file]}"
        puts "Host      => #{@options[:host]}"
        puts "Loc       => #{@options[:loc]}"
        puts "Title     => #{@options[:title]}"
        puts "Browser   => #{@options[:browser]}"
        puts "UserID    => #{@options[:userid]}"
        puts "Password  => #{@options[:password]}"
        puts "Eyes      => #{@options[:enable_eyes]}"
        puts "Test Cfg  => #{@options[:json_config_file]}"
        puts "Match Level => #{@options[:match_level]}"
        puts "Accounts    => #{@options[:accounts]}"
        puts "Viewport    => #{@options[:viewport]}"
        puts "Viewport (Var) => #{Scoutui::Base::UserVars.instance.getViewPort().to_s}"
        puts "PageModel file => #{@options[:page_model].to_s}"
      end

      @options
    end

    def isDebug?
      @options[:debug]
    end

    def eyesEnabled?
      @options[:enable_eyes]
    end

    def getLicenseFile()
      @options[:license_file].to_s
    end

    def getBrowser()
      getBrowserType()
    end
    def getBrowserType()
      @options[:browser]
    end

    def hasTestConfig?
      !@options[:json_config_file].nil?
    end

    def testConfigFile()
      @options[:json_config_file]
    end

    # Returns JSON file contents/format
    def getTestSettings()

      [:accounts, :browser, :host, :userid, :password].each do |k|

        puts __FILE__ + (__LINE__).to_s + " opt[test_config].has_key(#{k.to_s}) => #{@options[:test_config].has_key?(k.to_s)}" if Scoutui::Utils::TestUtils.instance.isDebug?

        puts __FILE__ + (__LINE__).to_s + " options[#{k}] : #{@options[k].to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
        if @options.has_key?(k) && !@options[k].nil?
          Scoutui::Base::UserVars.instance.set(k, @options[k].to_s)
        elsif @options[:test_config].has_key?(k.to_s)

          puts __FILE__ + (__LINE__).to_s + " opts[#{k}].nil => #{@options[k].nil?}" if Scoutui::Utils::TestUtils.instance.isDebug?
          # Ensure commnand line takes precedence
          if !@options[k].nil?
            puts __FILE__ + (__LINE__).to_s + " opt[#{k.to_s} => #{@options[k].to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            Scoutui::Base::UserVars.instance.set(k, @options[k].to_s)
          else
            Scoutui::Base::UserVars.instance.set(k, @options[:test_config][k.to_s].to_s)
          end

        elsif @env_list.has_key?(k)
          # If an ENV is available, use it.
          puts __FILE__ + (__LINE__).to_s + " #{k} => ENV(#{@env_list[k]}) = #{ENV[@env_list[k].to_s]}"  if Scoutui::Utils::TestUtils.instance.isDebug?
          Scoutui::Base::UserVars.instance.set(k, ENV[@env_list[k].to_s])
        end
      end

      puts __FILE__ + (__LINE__).to_s + " test_config => #{@options[:test_config]}"  if Scoutui::Utils::TestUtils.instance.isDebug?


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

          if Scoutui::Utils::TestUtils.instance.isDebug?
            puts __FILE__ + (__LINE__).to_s + " #{k} => #{_v}"
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