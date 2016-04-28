module Scoutui
  module UserVariables
    module Fetchers
      class Browser
        REGEX = /\{\{browser\.(.*)\}\}/

        def initialize(driver)
          @driver = driver
        end

        def fetch(variable_name)
          if variable_name =~ REGEX
            binding.pry
            attribute = variable_name.match(REGEX)[1]
            driver.send(attribute.to_sym)
          end
        end
      end
    end
  end
end
