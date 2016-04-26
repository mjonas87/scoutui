module Scoutui::Steps
  class Step
    attr_reader :name, :description, :url, :verification_node_finder, :actions

    def initialize(driver, step_node)
      @name = step_node['name']
      @description = step_node['description']
      @url = step_node['url']
      @verification_node_finder = step_node['verify']

      factory = Scoutui::Actions::ActionFactory.new(driver)
      action_texts = step_node.key?('action') ? [step_node['action']] : step_node['actions']
      @actions = action_texts.map { |action_text| factory.generate_action(action_text) }
    end
  end
end
