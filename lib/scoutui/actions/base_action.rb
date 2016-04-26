module Scoutui::Actions
  class BaseAction
    def initialize(driver)
      @driver = driver
    end

    def valid?
      true
    end

    def perform
      if valid?
        up
      else
        Scoutui::Logger::LogMgr.instance.info "Skipping #{self.class.name}".blue
      end
    end

    def up
      fail Exception, "'#{self.class.name}##{__method__}' is undefined."
    end
  end
end
