module Scoutui::Assertions
  class IfThen < BaseAssertion
    def self.parse_args(assertion_condition)
      results = assertion_condition['if'].match(/(.*)=(.*)/)
      [results[1], results[2], assertion_condition['then']]
    end

    def initialize(driver, model_node, if_operand_left, if_operand_right, then_xpath)
      super(driver, model_node)
      @if_operand_left = @user_vars.fill(if_operand_left)
      @if_operand_right = @user_vars.fill(if_operand_right)
      @then_xpath = @user_vars.fill(then_xpath)
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

    def print_result(result_text)
      Scoutui::Logger::LogMgr.instance.info 'If'.blue + " #{@if_operand_left} == #{@if_operand_right}".yellow + ' Then'.blue + @then_xpath.yellow + " : #{result_text}"
    end
  end
end
