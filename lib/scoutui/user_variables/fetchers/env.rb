module Scoutui
  module UserVariables
    module Fetchers
      class Env
        def fetch(variable_name)
          ENV.with_indifferent_access[variable_name]
        end
      end
    end
  end
end
