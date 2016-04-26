module Scoutui::Actions
  class Visit < BaseAction
    def initialize(driver, url)
      super(driver)

      raw_url = url.strip.start_with?('/') ? "#{Scoutui::Base::UserVars.instance.getHost}#{url}" : url
      @url = Scoutui::Base::UserVars.instance.normalize(raw_url)
    end

    def up
      @driver.navigate.to(@url)
    end

    def inspect
      Scoutui::Logger::LogMgr.instance.info "#{self.class.name.demodulize.titleize.yellow}: #{@url.green}"
    end
  end
end
