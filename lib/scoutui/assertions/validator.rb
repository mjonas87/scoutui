module Scoutui::Assertions
  class Validator
    def initialize(driver)
      @driver = driver
    end

    def validate(model_key, model_node)
      # return unless model_node.key?('visible_when')
      #
      # model_node.each { |key, node| validate(key, node)} if model_node['visible_when'].respond_to?(:each)

     # locator = model_node['locator']
      # element = Scoutui::Base::QBrowser.getFirstObject(@driver, locator)

      assertions(model_node).each { |a| a.run_assertion }

    #   case condition
    #     when 'always'
    #       declare_result(condition, locator) do
    #         element.displayed?
    #       end
    #       # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!element.nil?, "Verify #{model_key} - #{model_node['locator']} visible")
    #     when 'never'
    #       declare_result(condition, locator) do
    #         !element.displayed?
    #       end
    #       # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(element.nil?, "Verify #{model_key} #{model_node['locator']} not visible")
    #     else
    #       # TODO: More kinds of visibility assertions!
    #       # elsif assertion['visible_when'].match(/role\=/i)
    #   end
    end

    private

    def assertions(node)
      assertion_keys = %w"visible_when"

      node.keys.select { |key| assertion_keys.include?(key) }.map do |key|
        klass = "Scoutui::Assertions::#{key.camelize}".constantize
        klass.new(@driver, parse_condition(node[key]))
      end
    end

    def parse_condition(condition)
      simple_conditions = %w'always never'
      return condition if simple_conditions.include?(condition)
      fail Exception, 'Not handling this currently'
      # TODO: Add handling for things like => "visible_when": "click(page(research).get(fuel_economy))",
    end

    def declare_result(condition_text, locator)
      Scoutui::Logger::LogMgr.instance.info "Visible #{condition_text.titleize}?".blue + " : #{locator.yellow} : #{true.to_s.green}"
    end
  end
end
