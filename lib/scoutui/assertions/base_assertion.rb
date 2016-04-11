module Scoutui::Assertions
  class BaseAssertion
    def run_assertion
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
