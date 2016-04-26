module Scoutui::Steps
  class StepFactory
    def initialize(driver, factories)
      @driver = driver
      @factories = factories
    end

    def generate_step(step_node)
      Scoutui::Steps::Step.new(step_node['name'],
                               step_node['description'],
                               step_node['url'],
                               actions(step_node),
                               model_assertions(step_node)
                              )
    end

    private

    def actions(step_node)
      action_texts = step_node.key?('action') ? [step_node['action']] : step_node['actions']
      action_texts.map { |action_text| @factories[:action].generate_action(action_text) }
    end

    def model_assertions(step_node)
      if step_node.key?('verify')
        verification_node = Scoutui::Utils::TestUtils.instance.get_model_node(step_node['verify'])
        @factories[:page_component].generate_page_components(verification_node).map do |page_component|
          page_component.assertions
        end.flatten
      else
        []
      end
    end
  end
end
