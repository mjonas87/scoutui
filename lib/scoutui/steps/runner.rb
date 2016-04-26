module Scoutui::Steps
  class Runner
    def initialize(driver)
      @driver = driver
    end

    def run(step)
      step.actions.each do |action|
        action.inspect
        action.perform
      end
    end
  end
end
