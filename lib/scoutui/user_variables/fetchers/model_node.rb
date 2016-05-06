module Scoutui
  module UserVariables
    module Fetchers
      class ModelNode
        REGEX = /\{\{this\.(.*)\}\}/

        def initialize(model_node)
          @model_node = model_node
        end

        def fetch(variable_name)
          if variable_name =~ REGEX
            attribute = variable_name.match(REGEX)[1]
            @model_node[attribute]
          end
        end
      end
    end
  end
end
