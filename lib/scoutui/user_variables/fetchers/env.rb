module Scoutui::UserVariables::Fetchers
  class TestConfig
    def fetch(variable_name)
      ENV.with_indifferent_access[variable_name]
    end
  end
end
