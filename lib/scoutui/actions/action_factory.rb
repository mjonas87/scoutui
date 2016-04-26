module Scoutui::Actions
  class ActionFactory
    ALLOWED_ACTIONS = %w"fill_form click pause visit"

    def initialize(driver)
      @driver = driver
    end

    def generate_action(action_text)
      regex = "(#{ALLOWED_ACTIONS.join('|')})(\\((.*)\s*\\)=?(.*)?)?"
      result = action_text.match(regex)
      fail Exception, "Unknown action '#{action_text}'" if result.nil?

      klass = "Scoutui::Actions::#{result[1].camelize}".constantize
      args = [@driver] + result[3..4].select { |x| !x.nil? && x.length > 0 }
      klass.new(*args)
    end
  end
end
