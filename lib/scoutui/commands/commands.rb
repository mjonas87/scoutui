
module Scoutui::Commands

  class Command
    attr_accessor :description
    attr_accessor :drv
    attr_accessor :cmd
    attr_accessor :rc

    def initialize(_cmd, _drv=nil)
      puts __FILE__ + (__LINE__).to_s + "  Command: #{_cmd.to_s}"
      @cmd=_cmd
      @rc=nil
      @drv=_drv
    end

    def result
      @rc
    end

    def execute(_drv=nil, _dut=nil)
      raise NotImplementedError
    end

  end


end
