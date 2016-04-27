module Scoutui
  module UserVariables
    module Fetchers
      class TestConfig
        def fetch(variable_name)
          config = Scoutui::Utils::TestUtils.instance.getTestConfig.with_indifferent_access
          result = config.fetch('user_vars', {})[variable_name]
          return nil if result == {}
          result
        end
      end
    end
  end
end
