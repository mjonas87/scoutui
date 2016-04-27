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
      user_vars = Scoutui::Base::UserVars.new
      user_vars.normalize(super)
    end

    def page_element
      if @condition_text.match(/^\s*page\s*\(/)
        # Page reference
        Scoutui::Utils::TestUtils.instance.get_model_node(@condition_text)
      elsif Scoutui::Actions::Utils.instance.isCSS(@condition_text)
        # CSS
        { 'locator' => Scoutui::Actions::Utils.instance.isCSS(@condition_text) }
      elsif @condition_text.match(/^\s*page\s*\(/)
        # XPath
        Scoutui::Utils::TestUtils.instance.get_model_node(@condition_text)
        { 'locator' => @condition_text }
      end
    end
  end
end
