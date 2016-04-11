require 'singleton'

module Scoutui::Reporters
  class AssertionReporter
    include Singleton

    attr_accessor :root
    attr_accessor :commands

    def

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
