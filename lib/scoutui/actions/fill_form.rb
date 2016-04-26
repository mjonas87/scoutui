require_relative './actions'

module Scoutui::Actions
  class FillForm < BaseAction
    def initialize(driver, locator, value)
      super(driver)
      @locator = locator
      @value = Scoutui::Base::UserVars.instance.normalize(value)
    end

    def up
      element = Scoutui::Base::QBrowser.getObject(@driver, @locator)
      element.send_keys(@value)
    end

    def inspect
      Scoutui::Logger::LogMgr.instance.info "#{self.class.name.demodulize.titleize.yellow}: #{@locator.green} => #{@value.green}"
    end
  end
end
