module Scoutui::Assertions
  class VisibleWhen < BaseAssertion
    def self.parse_args(assertion_condition)
      [assertion_condition]
    end

    def initialize(driver, locator, condition)
      super(driver, locator)
      @condition = condition
    end

    def check?
      return check_complex? if @condition.is_a?(Hash)
      true
    end

    def up
      if @condition.is_a?(Hash)
        assert_complex
      else
        assert_simple
      end
    end

    private

    def assertion_element
      @assertion_element ||= Scoutui::Base::QBrowser.getObject(@driver, @locator)
    end

    def condition_element
      @condition_element ||= Scoutui::Base::QBrowser.getObject(@driver, @condition['locator'])
    end

    def check_complex?
      case @condition['type']
        when 'text'
          return condition_element.text.downcase == @condition['value'].downcase
        when 'value'
          return condition_element.value == @condition['value']
        else
          fail Exception, "Unknown 'complex' assertion condition"
      end
    end

    def assert_complex
      case @condition['type']
        when 'text'
          declare_result do |element|
            element.displayed?
          end
        when 'value'
          declare_result do |element|
            element.displayed?
          end
        else
          fail Exception, "Unknown 'complex' assertion condition"
      end
    end

    def assert_simple
      case @condition
        when 'always'
          declare_result do |element|
            element.displayed?
          end
        when 'never'
          declare_result do |element|
            !element.displayed?
          end
        else
          fail Exception, "Unknown 'simple' assertion condition"
      end
    end

    def print_result(result_text)
      Scoutui::Logger::LogMgr.instance.info "Visible When #{(@condition.is_a?(Hash) ? @condition['type'] : @condition).titleize}?".blue + " : #{@locator.yellow} : #{result_text}"
    end
  end
end
