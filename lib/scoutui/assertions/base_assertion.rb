module Scoutui::Assertions
  class BaseAssertion

    def run_assertion; end
    def description; end

    def initialize(driver, condition, locator, req = nil )
      @driver = driver
      @is_simple = condition.is_a?(Hash)
      @locator = locator
      @req = req
      @condition = condition
    end

    def condition_type
      return @condition if @is_simple
      @condition['type']
    end

    def condition_locator
      return nil if @is_simple
      @condition['locator']
    end

    def condition_value
      return nil if @is_simple
      @condition['value']
    end

    def element
      @element ||= Scoutui::Base::QBrowser.getObject(@driver, @locator)
    end

    def assert!
      run_assertion
      true
    end

    def assert
      assert!
    rescue AssertionFailureException => ex
      @message = ex.message
      return false
    end

    def failure_message
      @message ||= ''
    end
  end

  class AssertionFailureException < Exception
  end
end
