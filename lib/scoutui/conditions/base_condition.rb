module Scoutui::Conditions
  class BaseCondition
    def initialize(driver, condition_text)
      fail 'Argument is not a string' if condition_text.is_a?(String)
      @driver = driver
      @condition_text = condition_text
    end

    def description
      'Default Condition description.'
    end

    def self.match?(xpath_selector)
      xpath_selector.match()
    end
  end
end
