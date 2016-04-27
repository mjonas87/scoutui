module Scoutui
  module UserVariables
    module Fetchers
      class Globals
        def var_hash
          @var_hash ||= {
            :accounts => '/tmp/qa/accounts.yaml',
            :browser => 'chrome',
            :userid => nil,
            :password => nil,
            :host => nil,
            :localization => 'en-us'
          }
        end

        def fetch(variable_name)
          var_hash.with_indifferent_access[variable_name]
        end
      end
    end
  end
end
