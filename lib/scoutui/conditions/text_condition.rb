module Scoutui::Conditions
  class TextCondition < BaseCondition
    def self.regex
      /^\s*(text)\s*\(/
    end

    def evaluate
      # TODO: Assert has text
      page_element.match(Regexp.new(value))
    end

    def key
      @condition_text.match(/s*(.*)=\s*(.*)/)[1]
    end

    def value
      @condition_text.match(/s*(.*)=\s*(.*)/)[2]
    end

    def page_element
      if @condition_text.match(/^\s*page\s*\(/)
        # Page reference
        Scoutui::Utils::TestUtils.instance.get_model_node(@condition_text)
      elsif Scoutui::Actions::Utils.instance.isCSS(@condition_text)
        # CSS
        { 'locator' => Scoutui::Actions::Utils.instance.isCSS(@condition_text) }
      elsif @condition_text.match(/^\s*\//)
        # XPath
        Scoutui::Utils::TestUtils.instance.get_model_node(@condition_text)
        { 'locator' => @condition_text }
      end
    end
  end
end
