module Scoutui::Assertions
  class IsVisible < BaseAssertion
    def initialize(driver, conditions, req = nil )
      @driver = driver
      @conditions = conditions
      @req = req
    end

    def description
      "Verify #{@xpath_selector} is visible."
    end

    def run_assertion
      @req = Scoutui::Utils::TestUtils.instance.getReq() if @req.nil?

      @conditions.reject { |condition| condition.evaluate }.map(&:description)
      raise AssertionFailureException, @conditions.join(' | ') if @conditions.any?
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
  end

  class AssertionFailureException < Exception
  end
end
