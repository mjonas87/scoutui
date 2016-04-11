module Scoutui::Conditions
  class ValueCondition < TextCondition
    def self.regex
      /^\s*(value)\s*\(/
    end
  end
end
