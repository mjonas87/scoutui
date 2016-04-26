module Scoutui::Assertions
  class IfThen < BaseAssertion
    def self.parse_args(assertion_condition)
      results = assertion_condition['if'].match(/(.*)=(.*)/)
      [results[1], results[2], assertion_condition['then']]
    end

    def initialize(driver, locator, if_operand_left, if_operand_right, then_xpath)
      super(driver, locator)
      @if_operand_left = if_operand_left
      @if_operand_right = if_operand_right
      @then_xpath = then_xpath
    end

    def check?
      @if_operand_left == @if_operand_right
    end

    def up
      then_element = Scoutui::Base::QBrowser.getObject(@driver, @then_xpath)
      declare_result do |_assertion_element|
        !then_element.nil?
      end
    end

    def inspect
      Scoutui::Logger::LogMgr.instance.info 'If'.blue + " #{@if_operand_left} == #{@if_operand_right} ".yellow + 'Then'.blue + @then_xpath.yellow
    end
  end
end
