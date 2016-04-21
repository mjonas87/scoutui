module Scoutui::Assertions
  class VisibleWhen < BaseAssertion
    def description
      "Verify #{@xpath_selector} is visible."
    end

    def run_assertion
      if @condition.is_a?(Hash)
        assert_complex
      else
        assert_simple
      end
    end

    private

    def declare_result
      result = yield(element)
      result_text = result.to_s.colorize(result ? :green : :red)
      Scoutui::Logger::LogMgr.instance.info "Visible #{(@condition.is_a?(Hash) ? @condition[0] : @condition).titleize}?".blue + " : #{@locator.yellow} : #{result_text}"
    end

    def assert_complex
      case @condition[:type]
        when 'text'
          target_element = Scoutui::Base::QBrowser.getObject(@driver, @condition[:locator])
          declare_result do |element|
            return element.displayed?
          end if target_element.text == @condition[:value]
        when 'value'
        when 'select'
        when 'role'
        else
          # TODO: More kinds of visibility assertions!
          # elsif assertion['visible_when'].match(/role\=/i)
          fail Exception, "Unknown 'simple' assertion condition"
      end
    end

    def assert_simple
      case @condition
        when 'always'
          declare_result do |element|
            element.displayed?
          end
        # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!element.nil?, "Verify #{model_key} - #{model_node['locator']} visible")
        when 'never'
          declare_result do |element|
            !element.displayed?
          end
        # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(element.nil?, "Verify #{model_key} #{model_node['locator']} not visible")
        else
          fail Exception, "Unknown 'simple' assertion condition"
      end
    end
  end
end
