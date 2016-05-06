module Scoutui::Assertions
  class IfThen < BaseAssertion
    def self.parse_args(assertion_condition)
      results = assertion_condition['if'].match(/(.*)=(.*)/)
      [results[1], results[2], assertion_condition['then']]
    end

    def initialize(driver, model_node, if_operand_left, if_operand_right, then_xpath)
      super(driver, model_node)
      @if_operand_left = if_operand_left
      @if_operand_right = if_operand_right
      @then_xpath = then_xpath
    end

    def if_operand_left
      @user_vars.fill(@if_operand_left)
    end

    def if_operand_right
      @user_vars.fill(@if_operand_right)
    end

    def then_xpath
      @user_vars.fill(@then_xpath)
    end

    def check?
      if_operand_left == if_operand_right
    end

    def up
      then_element = Scoutui::Base::QBrowser.getObject(@driver, @then_xpath)
      declare_result do |_assertion_element|
        !then_element.nil?
      end
    end

    def print_result(result_text)
      condition_result = check?
      condition_text = condition_result.to_s.colorize(condition_result ? :green : :red)
      Scoutui::Logger::LogMgr.instance.info 'If'.blue + " #{if_operand_left} == #{if_operand_right}".yellow + " (#{condition_text})" + ' Then '.blue + then_xpath.yellow + " : #{result_text}"
    end

    def print_skip
      condition_result = check?
      condition_text = condition_result.to_s.colorize(condition_result ? :green : :red)
      Scoutui::Logger::LogMgr.instance.info 'If'.blue + " #{if_operand_left} == #{if_operand_right}".yellow + " (#{condition_text})" + ' Then '.blue + then_xpath.yellow + ' : Skipped'
    end
  end
end
