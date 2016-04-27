module Scoutui::Assertions
  class BaseAssertion
    def self.parse_args(assertion_condition); end

    def initialize(driver, model_node)
      @driver = driver
      @model_node = model_node
      @locator = @model_node['locator']
      @user_vars = Scoutui::Base::UserVars.new.with_fetcher_for_node(@model_node)
    end

    def check?
      true
    end

    def perform
      if check?
        begin
          up
        rescue Exception
          declare_result do |_element|
            false
          end
        end
      else
        Scoutui::Logger::LogMgr.instance.info "Skipping #{self.class.name}".blue
      end
    end

    def up
      fail Exception, "'#{self.class.name}##{__method__}' is undefined."
    end

    def declare_result
      result = yield(Scoutui::Base::QBrowser.getObject(@driver, @locator))
      result_text = result.to_s.colorize(result ? :green : :red)
      print_result(result_text)
    end

    def print_result(result_text)
      Scoutui::Logger::LogMgr.instance.info "#{self.class.name.demodulize.titleize} : #{result_text}"
    end
  end
end
