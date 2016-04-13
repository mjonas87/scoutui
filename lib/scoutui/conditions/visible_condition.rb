module Scoutui::Conditions
  class VisibleCondition < BaseCondition
    def self.regex
      /(visible)\((.*)\)/
    end

    def description
      "Verify #{@xpath_selector} is visible."
    end

    def evaluate
      locator = page_element['locator'].to_s
      node = Scoutui::Base::QBrowser.getFirstObject(@driver, locator)
      node.displayed?
    end

    def xpath_selector
      Scoutui::Base::UserVars.instance.normalize(super)
    end

    def page_element
      if @condition_text.match(/^\s*page\s*\(/)
        # Page reference
        Scoutui::Utils::TestUtils.instance.getPageElement(@condition_text)
      elsif Scoutui::Commands::Utils.instance.isCSS(@condition_text)
        # CSS
        { 'locator' => Scoutui::Commands::Utils.instance.isCSS(@condition_text) }
      elsif @condition_text.match(/^\s*page\s*\(/)
        # XPath
        Scoutui::Utils::TestUtils.instance.getPageElement(@condition_text)
        { 'locator' => @condition_text }
      end
    end
  end
end