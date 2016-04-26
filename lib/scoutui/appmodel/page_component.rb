module Scoutui::ApplicationModel
  class PageComponent
    attr_reader :locator, :assertions

    def initialize(locator, assertions)
      @locator = locator
      @assertions = assertions
    end
  end
end
