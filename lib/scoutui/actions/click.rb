module Scoutui::Actions
  class Click < BaseAction

    def initialize(driver, node_finder)
      super(driver)
      @node_finder = node_finder
    end

    def up
      element = Scoutui::Base::QBrowser.getObject(@driver, @node_finder)
      element.click
    end

    def inspect
      Scoutui::Logger::LogMgr.instance.info "#{self.class.name.demodulize.titleize.yellow}: #{@node_finder.green}"
    end
  end
end
