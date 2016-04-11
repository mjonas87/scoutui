module Scoutui::Conditions
  class TitleCondition < BaseCondition
    def self.regex
      /^\s*(title)\s*\(/
    end

    def evaluate
      current_title = @driver.title.strip
      expected_title = Regexp.new(@condition_text)
      current_title.match(expected_title)
    end
  end
end
