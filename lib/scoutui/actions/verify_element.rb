require_relative './actions'

module Scoutui::Actions
  class VerifyElement < Action
    def initialize(node, driver = nil)
      fail Exception, "Expected hash, received '#{node.class.to_s}.' ==> #{node}" unless node.is_a?(Hash)

      super(nil, driver)
      @node = node
    end

    def _verify(elt)
      begin

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " VerifyElement._verify(#{elt})"

        _k = elt.keys[0].to_s
        a = elt[_k]

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Assert => #{_k} :  #{a.to_s}"

        #    _k = 'generic-assertion'
        _v={}

        if a.is_a?(Hash)
          _v=a

          _req = Scoutui::Utils::TestUtils.instance.getReq()

          if _v.key?('locator')
            _locator = _v['locator'].to_s
            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

            #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

            _obj = Scoutui::Base::QBrowser.getFirstObject(@drv, _locator, Scoutui::Actions::Utils.instance.getTimeout())

            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}"
          end

          if _v.key?('visible_when')

            if _v['visible_when'].match(/always/i)
              Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + " Verify assertion #{_k} - #{_locator} visible - #{!_obj.nil?.to_s}"
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{_k} - #{_locator} visible")
            elsif _v['visible_when'].match(/never/i)
              Scoutui::Logger::LogMgr.instance.asserts.info "Verify assertion #{_k} #{_locator} not visible - #{obj.nil?.to_s}"
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(obj.nil?, "Verify assertion #{_k} #{_locator} not visible")
            elsif _v['visible_when'].match(/role\=/i)
              _role = _v['visible_when'].match(/role\=(.*)/i)[1].to_s
              _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify assertion object exists if the role #{_role} matches expected role #{_expected_role.to_s}"

              if _role==_expected_role.to_s
                Scoutui::Logger::LogMgr.instance.asserts.info "Verify assertion #{_k} #{_locator}  visible when role #{_role} - #{!_obj.nil?.to_s}"
                Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{_k} #{_locator}  visible when role #{_role}")
              end

            end
          end


        end

      rescue => ex

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " abort processing."
        Scoutui::Logger::LogMgr.instance.debug "Error during processing: #{ex}"
        puts __FILE__ + (__LINE__).to_s +  "\nBacktrace:\n\t#{ex.backtrace.join("\n\t")}"
      end
    end

    def execute(drv)
      @drv = drv unless drv.nil?
      nodes_to_verify(@node).each { |node| verify_node(node) }
    end

    private

    def nodes_to_verify(current_node)
      return [current_node] if current_node.key?('locator')
      current_node.map { |sub_node_key, sub_node| nodes_to_verify(sub_node) }.flatten
    end

    def verify_node(node)
      assertions(node).each { |a| a.run_assertion }



      if node.key?('visible_when') && node['visible_when'].match(/title\(/)
        current_title = @drv.title
        expected_title = Regexp.new(node['visible_when'].match(/title\((.*)\)/)[1].to_s)
        rc = !expected_title.match(current_title).nil?

        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Verify expected title (#{current_title}) matches (#{expected_title}) => " + rc.to_s

#       Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(expected_title==current_title, "Verify title matches #{expected_title}")
      end

      if node.key?('visible_when') && node['visible_when'].match(/(text|value)\s*\(/)
        condition = node['visible_when'].match(/(value|text)\((.*)\)/)[1].to_s
        tmpObj = node['visible_when'].match(/(value|text)\((.*)\)/)[2].to_s
        expectedVal = node['visible_when'].match(/(value|text)\s*\(.*\)\s*\=\s*(.*)/)[2].to_s
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " tmpObj => #{tmpObj} with expected value #{expectedVal}"

        xpath = Scoutui::Base::UserVars.instance.get(tmpObj)

        obj = Scoutui::Base::QBrowser.getObject(@drv, xpath)

        if !obj.nil?
          #  Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " value : #{obj.value.to_s}"
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " text  : #{obj.text.to_s}"

          if obj.tag_name.downcase.match(/(select)/)
            _opt = Selenium::WebDriver::Support::Select.new(obj)
            opts = _opt.selected_options
            Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " selected => #{opts.to_s}"

            opts.each do |o|
              Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "| <v, t>::<#{o.attribute('value').to_s},  #{o.text.to_s}>"
              desc=nil

              if condition=='text' && o.text==expectedVal
                desc=" Verify #{locator} is visible since condition (#{condition} #{xpath} is met."
              elsif condition=='value' && o.attribute('value').to_s==expectedVal
                desc=" Verify #{locator} is visible since #{condition} of #{xpath} is #{expectedVal}"
              end

              if !desc.nil?
                locatorObj = Scoutui::Base::QBrowser.getObject(@drv, locator)

                Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " LocatorObj : #{locatorObj} : #{!locatorObj.nil? && locatorObj.displayed?}"

                Testmgr::TestReport.instance.getReq('UI').tc('visible_when').add(!locatorObj.nil? && locatorObj.displayed?, desc)
              end
            end
          end

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " value : #{obj.attribute('value').to_s}"
        end

      end





    end

    def assertions(node)
      assertion_keys = %w"visible_when"
      assertions_node = node['assertions']
      assertions_node.keys.select { |key| assertion_keys.include?(key) }.map do |key|
        klass = "Scoutui::Assertions::#{key.camelize}".constantize
        klass.new(@drv, parse_condition(assertions_node[key]), node['locator'])
      end
    end

    def parse_condition(condition_text)
      simple_conditions = %w'always never'
      return condition_text if simple_conditions.include?(condition_text)
      condition_text

      # fail Exception, 'Not handling this currently'
      # TODO: Add handling for things like => "visible_when": "click(page(research).get(fuel_economy))",
    end
  end
end
