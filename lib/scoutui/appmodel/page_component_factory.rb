module Scoutui::ApplicationModel
  class PageComponentFactory
    COMPONENT_NODE_IDENTIFIER = 'locator'

    def initialize(assertion_factory)
      @assertion_factory = assertion_factory
    end

    def generate_page_components(node)
      if node.key?(COMPONENT_NODE_IDENTIFIER)
        locator = node['locator']
        assertions = node['assertions'].map do |assertion_key, assertion_condition|
          @assertion_factory.generate_assertion(locator, assertion_key, assertion_condition)
        end

        [PageComponent.new(locator, assertions)]
      elsif !node.is_a?(Hash)
        []
      else
        node.map { |_sub_node_key, sub_node| generate_page_components(sub_node) }.flatten
      end
    end
  end
end
