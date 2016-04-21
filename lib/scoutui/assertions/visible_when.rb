module Scoutui::Assertions
  class VisibleWhen < BaseAssertion
    def initialize(driver, condition, locator, extra_conditions = [], req = nil )
      @driver = driver
      @condition = condition
      @locator = locator
      @extra_conditions = extra_conditions
      @req = req
    end

    def description
      "Verify #{@xpath_selector} is visible."
    end

    def run_assertion
        case @condition
          when 'always'
            declare_result(@condition, @locator) do
              element.displayed?
            end
            # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!element.nil?, "Verify #{model_key} - #{model_node['locator']} visible")
          when 'never'
            declare_result(@condition, @locator) do
              !element.displayed?
            end
            # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(element.nil?, "Verify #{model_key} #{model_node['locator']} not visible")
          else
            # TODO: More kinds of visibility assertions!
            # elsif assertion['visible_when'].match(/role\=/i)
        end


      # @req = Scoutui::Utils::TestUtils.instance.getReq() if @req.nil?
      # @extra_conditions.reject { |condition| condition.evaluate }.map(&:description)
      # raise AssertionFailureException, @extra_conditions.join(' | ') if @extra_conditions.any?
    end

    private

    def check_conditions
    end

    def check_visiblity_condition
      ##
      # expected:
      #   wait: page(abc).get(def)    where this @xpath_selector has "locator"

      locator = page_object['locator'].to_s

      first_object = Scoutui::Base::QBrowser.getFirstObject(@driver, locator)

      unless first_object.nil?
        is_visible = first_object.displayed?
      end

      raise AssertionFailureException, "#{@xpath_selector} was not visible." unless is_visible

      # TODO: Derive from Assertions
      Testmgr::TestReport.instance.getReq(@req).get_child('visible').add(is_visible, "Verify #{@xpath_selector} is visible")
    end

    def declare_result(condition_text, locator)
      Scoutui::Logger::LogMgr.instance.info "Visible #{condition_text.titleize}?".blue + " : #{locator.yellow} : #{true.to_s.green}"
    end
  end
end
