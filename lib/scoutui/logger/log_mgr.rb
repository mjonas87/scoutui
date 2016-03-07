

require 'singleton'
require 'logging'

module Scoutui::Logger



  class LogMgr
    include Singleton

    attr_accessor :root
    attr_accessor :commands

    def initialize

      @root = Logging.logger(STDOUT)
      @root.level = :debug

      Logging.appenders.stderr('Standard Error', :level => :error)

      # Logging.appenders.file('Command File', :filename => 'command.log')
      # Logging.logger['Commands'].appenders = 'Command File'

      @asserts = Logging.logger['Assertions']
      @asserts.add_appenders(
                  Logging.appenders.stdout
      )
      @asserts.add_appenders(
                  Logging.appenders.file("assertions.log")
      )

      @asserts.level = :debug

      @commands = Logging.logger['Commands']
      @commands.add_appenders(
                   Logging.appenders.stdout,
                   Logging.appenders.file('commands.log')
      )
      @commands.level = :debug

      #Logging.logger.root.level = :warn
    end

    def asserts
      @asserts
    end

    def command
      @commands
    end
    def commands
      @commands
    end

    def setLevel(_level)
      @root.level = _level.to_sym
    end

    def warn(txt)
      log('warn', txt)
    end

    def err(txt)
      error(txt)
    end

    def error(txt)
      log('error', txt)
    end

    def fatal(txt)
      log('fatal', txt)
    end

    def info(txt)
      log('info', txt)
    end

    def debug(txt)
      log('debug', txt)
    end


    def log(level, txt)

      if level.match(/info/i)
        @root.info txt
      elsif level.match(/warn/i)
        @root.warn txt
      elsif level.match(/debug/i)
        @root.debug txt
      elsif level.match(/error/i)
        @root.error txt
      elsif level.match(/fatal/i)
        @root.fatal txt
      end

    end

  end


end
