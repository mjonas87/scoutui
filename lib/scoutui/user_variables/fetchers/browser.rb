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
            attribute = variable_name.match(REGEX)[1]

            case attribute
              when 'current_path'
                URI.parse(@driver.current_url).path
              else
                @driver.send(attribute.to_sym)
            end

          end
        end
      end
    end
  end
end
