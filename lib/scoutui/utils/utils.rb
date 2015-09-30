require 'rubygems'
require 'singleton'
require 'pp'
require 'optparse'


module Scoutui::Utils


  class TestUtils
    include Singleton

    attr_accessor :options

    def initialize

      @options={}

      [:test_file, :host, :loc, :title, :browser, :userid, :password, :json_config_file, :test_config, :debug].each do |o|
        o=nil
      end

      @options[:enable_eyes]=true
    end

    def parseCommandLine()
      @options = {}
      OptionParser.new do |opt|
        opt.on('-c', '--config TESTFILE') { |o|
            if !o.nil?
              @options[:json_config_file]=o

              jFile = File.read(@options[:json_config_file])
              @options[:test_config]=jsonData=JSON.parse(jFile)
            end
        }
        opt.on('-d', '--debug Bool')    { |o| @options[:debug] = (o.to_s.downcase=='true')}
        opt.on('-h', '--host HOST')     { |o| @options[:host] = o }
        opt.on('-l', '--lang LOCAL')    { |o| @options[:loc] = o }
        opt.on('-t', '--title TITLE')   { |o| @options[:title] = o }
        opt.on('-b', '--browser BROWSER') { |o| @options[:browser] = o }
        opt.on('-u', '--user USER_ID')  { |o|
          @options[:userid] = o
          Scoutui::Base::UserVars.instance.setVar(:user, @options[:userid].to_s)
        }
        opt.on('-p', '--password PASSWORD') { |o| @options[:password] = o }
        opt.on('-e', '--eyes Boolean') { |o|
          if !o.nil?
            if !o.match(/true|1/i).nil?
              @options[:enable_eyes]=true
            end

          end

        }
      end.parse!

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

      @options
    end

    def isDebug?
      @options[:debug]
    end

    def eyesEnabled?
      @options[:enable_eyes]
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

      [:browser, :host, :userid, :password].each do |k|

        puts __FILE__ + (__LINE__).to_s + " opt[test_config].has_key(#{k.to_s}) => #{@options[:test_config].has_key?(k.to_s)}"
        if @options[:test_config].has_key?(k.to_s)

          puts __FILE__ + (__LINE__).to_s + " opts[#{k}].nil => #{@options[k].nil?}"
          # Ensure commnand line takes precedence
          if !@options[k].nil?
            puts __FILE__ + (__LINE__).to_s + " opt[#{k.to_s} => #{@options[k].to_s}"
            Scoutui::Base::UserVars.instance.set(k, @options[k].to_s)
          else

            Scoutui::Base::UserVars.instance.set(k, @options[:test_config][k.to_s].to_s)
          end

        end
      end

      @options[:test_config]
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


    def title()
      @options[:title]
    end

  end








end