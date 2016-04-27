module Scoutui
  module Actions
    class Visit < BaseAction
      def initialize(driver, url)
        super(driver)

        user_vars = Scoutui::Base::UserVars.new
        raw_url = url.strip.start_with?('/') ? "#{user_vars.getHost}#{url}" : url
        @url = user_vars.normalize(raw_url)
      end

      def up
        @driver.navigate.to(@url)
      end

      def inspect
        Scoutui::Logger::LogMgr.instance.info "#{self.class.name.demodulize.titleize.yellow}: #{@url.green}"
      end
    end
  end
end
