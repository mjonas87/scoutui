module Scoutui::Steps
  class Step
    attr_reader :name, :description, :url, :actions, :model_assertions

    def initialize(name, description, url, actions, model_assertions)
      @name = name
      @description = description
      @url = url
      @actions = actions
      @model_assertions = model_assertions
    end

    def inspect
    end
  end
end
