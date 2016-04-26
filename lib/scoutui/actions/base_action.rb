module Scoutui::Actions
  class BaseAction
    def initialize(driver)
      @driver = driver
    end

    def perform
      up
    end

    def up
      fail Exception, "'#{self.class.name}#perform' is undefined."
    end
  end
end
