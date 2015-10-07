
require 'singleton'
require 'pp'
require 'optparse'


module Scoutui::Utils


  class TestUtils
    include Singleton

    attr_accessor :options

    def initialize

      @env_list={:accounts => 'SCOUTUI_ACCOUNTS', :browser => 'SCOUTUI_BROWSER', :applitools_api_key => 'APPLITOOLS_API_KEY'}
      @options={}

      [:accounts, :browser, :test_file, :host, :loc, :title,
       :userid, :password, :json_config_file, :test_config, :debug].each do |o|
        @options[o]=nil
      end

      @options[:enable_eyes]=false
      @options[:match_level]='strict'
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
        opt.on('-b', '--browser [TYPE]', [:chrome, :firefox, :ie, :safari], "Select browser (chrome, ie, firefox, safari)") { |o| @options[:browser] = o }
        opt.on('-d', '--debug Bool')    { |o| @options[:debug] = (o.to_s.downcase=='true')}
        opt.on('-h', '--host HOST')     { |o| @options[:host] = o }
        opt.on('-l', '--lang LOCAL')    { |o| @options[:loc] = o }
        opt.on('-k', '--key EyesLicense') { |o| options[:license_file] = o }
        opt.on('-a', '--app AppName')   { |o| @options[:app] = o }
        opt.on('--match [TYPE]', [:layout2, :layout, :strict, :exact, :content], "Select match level (layout, strict, exact, content)") { |o| @options[:match_level] = o }
        opt.on('-t', '--title TITLE')   { |o| @options[:title] = o }

        opt.on('-u', '--user USER_ID')  { |o|
          @options[:userid] = o
          Scoutui::Base::UserVars.instance.setVar(:user, @options[:userid].to_s)
        }
        opt.on('-p', '--password PASSWORD') { |o| @options[:password] = o }
        opt.on('-e', '--eyes', "Toggle eyes") {
          @options[:enable_eyes]=true
        }
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

      ['match_level', 'title', 'app'].each do |k|

        _v=nil

        if @options[:test_config].has_key?('eyes')
          _v=@options[:test_config]['eyes'][k].to_s
        end

        if !@options[k.to_sym].nil?
          _v=@options[k.to_sym].to_s
        end

        if Scoutui::Utils::TestUtils.instance.isDebug?
          puts __FILE__ + (__LINE__).to_s + " #{k} => #{_v}"
        end

        Scoutui::Base::UserVars.instance.set('eyes.' + k, _v)

      end

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