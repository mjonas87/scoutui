module Scoutui::UserVariables::Fetchers
  class Globals
    GLOBALS = {
        :accounts => '/tmp/qa/accounts.yaml',
        :browser => 'chrome',
        :userid => nil,
        :password => nil,
        :host => nil,
        :localization => 'en-us'
    }

    def fetch(variable_name)
      GLOBALS.with_indifferent_access[variable_name]
    end
  end
end
