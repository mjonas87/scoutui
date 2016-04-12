
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
      @cmd=_cmd
      @rc=nil
      @drv=_drv
      @locator=nil
      @executed=false
      @executed_result=nil
    end

    def setResult(r)
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
