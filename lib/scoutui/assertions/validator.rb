module Scoutui::Assertions
  class Validator
    def initialize(driver)
      @driver = driver
    end

    def validate(model_key, model_node)
      assertions(model_node).each { |a| a.perform }
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
  end
end
