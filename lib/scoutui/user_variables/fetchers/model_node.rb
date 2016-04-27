module Scoutui::UserVariables::Fetchers
  class TestConfig
    REGEX = /this\.(.*)/
    def fetch(variable_name, model_node)
      if variable_name =~ REGEX
        attribute = variable_name.match(REGEX)[1]
        model_node[attribute]
      end
    end
  end
end
