module Scoutui::Steps
  class Runner
    def initialize(driver)
      @driver = driver
    end

    def run(step)
      step.inspect

      step.actions.each do |action|
        action.inspect
        action.perform
      end

      step.model_assertions.each { |model_assertion| model_assertion.perform }
    end
  end
end
