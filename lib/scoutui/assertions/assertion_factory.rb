module Scoutui::Assertions
  class AssertionFactory
    ALLOWED_ASSERTIONS = %w"visible_when if_then"

    def initialize(driver)
      @driver = driver
    end

    def generate_assertion(model_node, assertion_key, assertion_condition)
      fail Exception, "Unknown assertion '#{assertion_key}'" unless ALLOWED_ASSERTIONS.include?(assertion_key)

      klass = "Scoutui::Assertions::#{assertion_key.camelize}".constantize
      args = [@driver, model_node] + klass.parse_args(assertion_condition)
      klass.new(*args)
    end
  end
end
