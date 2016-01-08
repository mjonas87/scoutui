require_relative './commands'

module Scoutui::Commands

  class FillForm < Command
    attr_accessor :form
    attr_accessor :formLocator
    attr_accessor :dut

    def initialize(_cmd)
      super(_cmd)

      @dut=nil

      puts __FILE__ + (__LINE__).to_s + " form => #{@cmd}"
      @formLocator = @cmd.match(/fillform\((.*)\s*\)/)[1].to_s
      @form = Scoutui::Utils::TestUtils.instance.getForm(@formLocator)
      puts __FILE__ + (__LINE__).to_s + " Form => #{@form}"
      @form.dump()
    end

    def fill(drv, dut)
      @drv=drv if !drv.nil?

      @form.fillForm(@drv, dut)
    end

    def execute(drv=nil)
      @drv=drv if !drv.nil?


      #_form = @cmd.match(/fillform\((.*)\s*\)/)[1].to_s
      #  _dut = _action.match(/fillform\(.*,\s*(.*)\)/)[1].to_s

      # dut = e['page']['dut']

      #  puts __FILE__ + (__LINE__).to_s + " _dut => #{_dut}"
      puts __FILE__ + (__LINE__).to_s + " DUT => #{@dut}"
      _f = Scoutui::Utils::TestUtils.instance.getForm(@formLocator)
      _f.dump()
      _f.verifyForm(@drv)
      _f.fillForm(@drv, dut)
    end

  end


end