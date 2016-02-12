
module Scoutui::Commands

  class Command
    attr_accessor :description
    attr_accessor :drv
    attr_accessor :cmd
    attr_accessor :rc
    attr_accessor :locator
    attr_accessor :executed
    attr_accessor :executed_result

    def initialize(_cmd, _drv=nil)
      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + "  Command.init: #{_cmd.to_s}"
      @cmd=_cmd
      @rc=nil
      @drv=_drv
      @locator=nil
      @executed=false
      @executed_result=nil
    end

    def setResult(r)
      Scoutui::Logger::LogMgr.instance.commands.debug " setResult(#{r.to_s})"
      @executed=true
      @executed_result=r
    end

    def executedResult
      @executed_result
    end

    def wasExecuted?
      @executed
    end

    def setLocator(_locator)
      @locator=_locator
    end

    def getLocator()
      @locator
    end

    def result
      @rc
    end

    def execute(_drv=nil, _dut=nil)
      raise NotImplementedError
    end

  end


end
