#require 'testmgr'

module Scoutui::Base
  class VisualTestFramework

    STEP_KEY = 'page'
    CMD_KEY = 'dut'   # Used to indicate the command file (YML) to execute

    def initialize

    end


    def self.processPageElement(driver, k, selector)
      _obj = nil


      # TODO: Re-add?
      # fail Exception, "Regex did not conform to expected pattern: '#{selector}'" if selector.match(/^\s*page\(.*\)\s*$/).nil?

      model_node, model_key = Scoutui::Utils::TestUtils.instance.getPageElement(selector)
      assertion_validator = Scoutui::Assertions::Validator.new(driver)
      assertion_validator.validate(model_key, model_node)

      #   sub_node_count = 0
      #   if model_node.is_a?(Hash)
      #     sub_node_count = model_node.select { |_s| model_node[_s].key?('locator') if model_node[_s].is_a?(Hash) &&  !model_node[_s].nil?  }.size
      #   end
      #
      #   if model_node.is_a?(Hash) && model_node.key?('locator')
      #
      #     selector = model_node['locator'].to_s
      #     element = Scoutui::Base::QBrowser.getFirstObject(driver, selector)
      #     _req = nil
      #
      #     if model_node.key?('reqid')
      #       _req=model_node['reqid'].to_s
      #     end
      #
      #     Scoutui::Base::Assertions.instance.assertPageElement(k, model_node, element, driver, _req)
      #   elsif sub_node_count > 0
      #     model_node.each_pair do |sub_node_key, sub_node|
      #       if sub_node.is_a?(Array)
      #         Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Arrays - TBD => #{sub_node}"
      #       end
      #
      #       if sub_node.is_a?(String)
      #         puts __FILE__ + (__LINE__).to_s + " #{sub_node} is a string - next"
      #         next
      #       end
      #
      #       if sub_node.key?('assert_when') && sub_node['assert_when'].match(/role\s*\=/i)
      #         _role = sub_node['assert_when'].match(/role\s*\=(.*)/i)[1].to_s
      #         _expected_role = Scoutui::Utils::TestUtils.instance.getRole
      #
      #         Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Trigger: expected : #{_expected_role.to_s}, actual: #{_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
      #
      #         if !_expected_role.nil? && !_role.match(/#{_expected_role}/i)
      #           Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Skip assertion since conditional assertion #{sub_node['assert_when']} not met" if Scoutui::Utils::TestUtils.instance.isDebug?
      #           next
      #         elsif _expected_role.nil?
      #           Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Skip role based assertion since role was not provided" if Scoutui::Utils::TestUtils.instance.isDebug?
      #           next
      #         end
      #         Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists since the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
      #       end
      #
      #       _req = nil
      #
      #       if sub_node.key?('reqid')
      #         _req=sub_node['reqid'].to_s
      #       end
      #
      #       fail Exception, "Node with key '#{sub_node_key}' does not have a 'locator' attribute." unless sub_node.key?('locator')
      #
      #       locator = sub_node['locator']
      #       element = Scoutui::Base::QBrowser.getFirstObject(driver, locator, Scoutui::Commands::Utils.instance.getTimeout)
      #
      #       if Scoutui::Base::Assertions.instance.visible_when_always(sub_node_key, sub_node, element, _req)
      #         next
      #       elsif Scoutui::Base::Assertions.instance.visible_when_never(sub_node_key, sub_node, element, _req)
      #         next
      #       elsif Scoutui::Base::Assertions.instance.visible_when_title(sub_node_key, sub_node, element, driver, _req)
      #         next
      #       elsif Scoutui::Base::Assertions.instance.visible_when_value(sub_node_key, sub_node, driver, _req)
      #         next
      #       elsif sub_node.key?('visible_when') && !sub_node['visible_when'].is_a?(Array)
      #
      #         if sub_node['visible_when'].match(/role\=/i)
      #           _role = sub_node['visible_when'].match(/role\=(.*)/i)[1].to_s
      #           _expected_role = Scoutui::Utils::TestUtils.instance.getRole
      #
      #           Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists if the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
      #
      #           if _role==_expected_role.to_s
      #             Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{sub_node_key} #{locator}  visible when role #{_role} - #{!element.nil?.to_s}"
      #             Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!element.nil?, "Verify #{sub_node_key} #{locator}  visible when role #{_role}")
      #           end
      #
      #         end
      #       elsif sub_node.key?('visible_when') && sub_node['visible_when'].is_a?(Array)
      #         Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when : (Array) - TBD  #{sub_node['visible_when']}"
      #         sub_node['visible_when'].each do |_vwhen|
      #           puts __FILE__ + (__LINE__).to_s + " #{_vwhen}  #{_vwhen.class}"
      #           Scoutui::Base::Assertions.instance.assertPageElement(sub_node_key, _vwhen, element, driver, _req)
      #         end
      #       end
      #     end
      #
      #     return
      #   elsif selector.is_a?(Hash)
      #     selector.each_pair do |sub_node_key, sub_node|
      #       fail Exception, "Node with key '#{}' does not have a 'locator' attribute." unless sub_node.key?('locator')
      #
      #       locator = sub_node['locator'].to_s
      #       element = Scoutui::Base::QBrowser.getFirstObject(driver, locator)
      #     end
      #   end
      # end

      # element
    end

    def self.processCommand(_action, e, driver)
      _req = Scoutui::Utils::TestUtils.instance.getReq
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " ===  Process ACTION : #{_action}  ==="  if Scoutui::Utils::TestUtils.instance.isDebug?

      if Scoutui::Commands::Utils.instance.isExistsAlert?(_action)
        _c = Scoutui::Commands::JsAlert::ExistsAlert.new(_action)
        _rc = _c.execute(driver)
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " existsAlert => #{_rc}"

        Scoutui::Logger::LogMgr.instance.asserts.info "Verify alert is present - #{!_rc.nil?.to_s}"
        Testmgr::TestReport.instance.getReq(_req).get_child('expectJsAlert').add(!_rc.nil?, "Verify alert is present")

      elsif Scoutui::Commands::Utils.instance.isVerifyForm?(_action)
        _c = Scoutui::Commands::VerifyForm.new(_action)
        _c.execute(driver)

      elsif !_action.match(/fillform\(/).nil? && false

     #   _c = Scoutui::Commands::FillForm.new(_action)

        _form = _action.match(/fillform\((.*)\s*\)/)[1].to_s
     #  _dut = _action.match(/fillform\(.*,\s*(.*)\)/)[1].to_s

        dut = e[STEP_KEY]['dut']

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " DUT => #{dut}" if Scoutui::Utils::TestUtils.instance.isDebug?
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.dump
        _f.verifyForm(driver)
        _f.fillForm(driver, dut)

      elsif !_action.match(/submitform\(/).nil? && false
        _cmd = Scoutui::Commands::SubmitForm.new(_action)
     #   _cmd.execute(driver)

        _form = _action.match(/submitform\((.*)\s*\)/)[1].to_s
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.submitForm(driver)

      elsif !_action.match(/type\(/).nil?  && false
        _selector = _action.match(/type\((.*),\s*/)[1].to_s
        _val   = _action.match(/type\(.*,\s*(.*)\)/)[1].to_s

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_selector}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(driver, _selector)

        if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password|email)/).nil?
          Scoutui::Logger::LogMgr.instance.commands.info "send_keys(#{_val})"
          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
        else
          Scoutui::Logger::LogMgr.instance.warn __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
        end

      end


    end

    def self.isRun(e)
      _run=nil
      if e[STEP_KEY].key?("run")
        _run = e[STEP_KEY].key?("run").to_s
      end
      _run
    end

    def self.isSnapIt(e)
      _snapit=false

      if e[STEP_KEY].key?("snapit")
        _snapit = !(e[STEP_KEY]["snapit"].to_s.match(/true/i).nil?)
      end
      _snapit
    end

    def self.verifyCondition(driver, selector)

      if !selector.match(/^page\([\w\d]+\)/).nil?
        model_node = Scoutui::Utils::TestUtils.instance.getPageElement(selector)

        if model_node.is_a?(Hash) && model_node.key?('locator')
          selector = model_node['locator'].to_s
        elsif selector.is_a?(Hash)
          selector.each_pair do |_k, _v|
            Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}"

            if _v.key?('locator')
              locator = _v['locator'].to_s
              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + locator
              _obj = Scoutui::Base::QBrowser.getFirstObject(driver, locator)

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{locator} => #{!_obj.nil?}"
            end
          end
        end
      end
    end

    def self.processCommandAssertions(driver, e)
      Scoutui::Logger::LogMgr.instance.info 'Process Command Assertions'.yellow

      unless e[STEP_KEY].key?('assertions') && e[STEP_KEY]['assertions'].size > 0
        Scoutui::Logger::LogMgr.instance.info 'No assertions present'.yellow
        return
      end

      _req = Scoutui::Utils::TestUtils.instance.getReq
      e[STEP_KEY]['assertions'].each do |assertion_node|
        assertion_key = assertion_node.keys[0].to_s
        assertion = assertion_node[assertion_key]

        Scoutui::Logger::LogMgr.instance.info "Assert => #{assertion_key}: #{assertion.to_s}".blue

        if assertion.is_a?(Hash)
          if assertion.key?('reqid')
            _req = assertion['reqid']
          end

          if assertion.key?('locator')
            locator = assertion['locator'].to_s

            if !locator.match(/^page\([\w\d]+\)/).nil?
              _obj = processPageElement(driver, assertion_key, locator)
            else
              _obj = Scoutui::Base::QBrowser.getFirstObject(driver, locator, Scoutui::Commands::Utils.instance.getTimeout)
            end
          end

          if assertion.key?('visible_when')
            if assertion['visible_when'].match(/always/i)
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{assertion_key} - #{locator} visible")
            elsif Scoutui::Base::Assertions.instance.visible_when_never(assertion_key, assertion, _obj, _req)
              ;
            elsif assertion['visible_when'].match(/role\=/i)
              _role = assertion['visible_when'].match(/role\=(.*)/i)[1].to_s
              _expected_role = Scoutui::Utils::TestUtils.instance.getRole

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify assertion object exists if the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

              if _role==_expected_role.to_s
                Scoutui::Logger::LogMgr.instance.asserts.info "Verify assertion #{assertion_key} #{locator}  visible when role #{_role} - #{!_obj.nil?.to_s}"
                Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{assertion_key} #{locator}  visible when role #{_role}")
              end
            end
          end
        end
      end
    end

    def self.processModelAssertions(driver, command_node)
      Scoutui::Logger::LogMgr.instance.info 'Process Model Assertions'.yellow
      Scoutui::Logger::LogMgr.instance.info 'No node specified to verify'.red unless command_node['page'].key?('verify')

      model_node = Scoutui::Utils::TestUtils.instance.getPageElement(command_node['page']['verify'])[0]
      Scoutui::Commands::VerifyElement.new(model_node, driver).execute(driver)
    end

    def self.processExpected(driver, e)
      Scoutui::Logger::LogMgr.instance.info 'Process Expectations'.yellow
      return unless e[STEP_KEY].key?('expected')
      return unless Scoutui::Utils::TestUtils.instance.assertExpected?

      Scoutui::Base::Assertions.instance.setDriver(driver)
      _req = Scoutui::Utils::TestUtils.instance.getReq
      expected = e[STEP_KEY]['expected']

      process_expected_as_array(driver, expected) if expected.is_a?(Array)
      process_expected_as_hash(driver, expected) if expected.is_a?(Hash)
    end

    def self.processFile(eyeScout, test_settings, strategy=nil)
      fail Exception, "Unable to find test data file '#{test_settings['dut']}' using key 'dut'" if test_settings['dut'].nil?
      driver = eyeScout.drv

      baseUrl = Scoutui::Base::UserVars.instance.getHost
      datafile = test_settings['dut']

      valid_file=false
      i=0
      commands = YAML.load_stream(File.read(datafile))
      valid_file=true

      return if !valid_file

      commands.each do |command_node|
        totalWindows = driver.window_handles.length

        puts 'Command to Process'.blue
        ap(command_node)
        i += 1

        Scoutui::Utils::TestUtils.instance.setReq('UI')
        Scoutui::Commands::Utils.instance.resetTimeout

        _action = command_node[STEP_KEY]["action"]
        _name   = command_node[STEP_KEY]["name"]
        _url    = command_node[STEP_KEY]["url"]
        _skip   = command_node[STEP_KEY]["skip"]
        _region = command_node[STEP_KEY]["region"]
        _reqid  = command_node[STEP_KEY]["reqid"]

        if command_node[STEP_KEY].key?("timeout")
         Scoutui::Commands::Utils.instance.setTimeout(command_node[STEP_KEY]["timeout"])
        end

        if !_reqid.nil? && !_reqid.to_s.empty?
          Testmgr::TestReport.instance.getReq(_reqid)
          Scoutui::Utils::TestUtils.instance.setReq(_reqid)
        else
          Scoutui::Logger::LogMgr.instance.debug 'REQID was not provided'.red
        end

        skipIt = (!_skip.nil?) && (_skip.to_s.strip.downcase=='true')

        if skipIt
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " SKIP - #{_name}" if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end


        if !isRun(command_node).nil?
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " ========> RUN <================="
          tmpSettings=test_settings.dup
          tmpSettings["dut"]=e[STEP_KEY]["run"].to_s

          Scoutui::Logger::LogMgr.instance.info " RUN Command file : #{tmpSettings["dut"]}"
          processFile(eyeScout, tmpSettings, strategy)
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Completed execution of subfile"
          next

        end

        if !(_action.nil? || _action.to_s.empty?)
          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_action} is valid - #{Scoutui::Commands::Utils.instance.isValid?(_action).to_s}"
          Testmgr::TestReport.instance.getReq('Command').get_child('isValid').add(Scoutui::Commands::Utils.instance.isValid?(_action), "Verify #{_action} is valid")

          begin
            _command = eyeScout.getStrategy.processCommand(_action, command_node)

            if driver.window_handles.length > totalWindows
              Scoutui::Logger::LogMgr.instance.info "[post-cmd] Total Windows : #{driver.window_handles.length.to_s}"
            end

            if !_command.wasExecuted?
              processCommand(_action, command_node, driver)
            end

            processExpected(driver, command_node)
            processCommandAssertions(driver, command_node)
            processModelAssertions(driver, command_node)


            if isSnapIt(command_node)
              if !_region.nil?
                eyeScout.check_window(_name, _region)
              else
                eyeScout.check_window(_name)
              end
            end
          rescue => ex
            "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
          end

          next
        end


        if command_node[STEP_KEY].key?("url")
          url = command_node[STEP_KEY]["url"].to_s
          eyeScout.getStrategy.processCommand('navigate(' + url + ')', command_node)
        end

        processExpected(driver, command_node)
        processCommandAssertions(driver, command_node)
        processModelAssertions(driver, command_node)

         if !_region.nil?
          eyeScount.check_window(_name, _region)
        else
          eyeScout.check_window(_name)
        end

        if command_node[STEP_KEY].key?('links')
          links = command_node[STEP_KEY]['links']

          links.each_pair do |link_name, selector|
            Scoutui::Logger::LogMgr.instance.info "\t\t#{link_name} => #{selector}"  if Scoutui::Utils::TestUtils.instance.isDebug?

            obj = QBrowser.getObject(driver, selector)
            Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " [click]: link object => #{obj.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            obj.click

            if !_region.nil?
              eyeScount.check_window(_name, _region)
            else
              eyeScout.check_window(link_name)
            end
          end
        end
      end
    end

    private

    def self.process_expected_as_array(driver, expected)
      expected.each { |condition| verifyCondition(driver, condition) }
    end

    def self.process_expected_as_hash(driver, expected)
      expected.each_pair do |link_name, selector|
        selector = Scoutui::Base::UserVars.instance.normalize(selector) unless selector.match(/\$\{.*\}/).nil?

        unless selector.match(/^page\([\w\d]+\)/).nil?
          model_node = Scoutui::Utils::TestUtils.instance.getPageElement(selector)
          next unless model_node.is_a?(Hash)

          sub_node_count = model_node.select { |child| model_node[child].is_a?(Hash) && !model_node[child].nil? && model_node[child].key?('locator') }.size

          if model_node.is_a?(Hash) && model_node.key?('locator')
            process_element(driver, selector, model_node)
          elsif sub_node_count > 0
            model_node.each_pair do |sub_node_key, sub_node|
              next if sub_node.is_a?(String)

              # TODO: Not sure what this does
              if sub_node.key?('assert_when') && sub_node['assert_when'].match(/role\s*\=/i)
                _role = sub_node['assert_when'].match(/role\s*\=(.*)/i)[1].to_s
                _expected_role = Scoutui::Utils::TestUtils.instance.getRole

                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Trigger: expected : #{_expected_role.to_s}, actual: #{_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

                if !_expected_role.nil? && !_role.match(/#{_expected_role}/i)
                  Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Skip assertion since conditional assertion #{sub_node['assert_when']} not met" if Scoutui::Utils::TestUtils.instance.isDebug?
                  next
                elsif _expected_role.nil?
                  Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Skip role based assertion since role was not provided" if Scoutui::Utils::TestUtils.instance.isDebug?
                  next
                end

                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists since the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
              end

              next unless sub_node.key?('locator')
              process_element(driver, sub_node_key, sub_node)
            end

            next
          elsif selector.is_a?(Hash)
            fail Exception, 'HOLY CRIPES YOU HIT THIS PART OF THE CODE. FREAK OUT!!!'

            selector.each_pair do |_k, _v|
              if _v.key?('locator')
                locator = _v['locator'].to_s
                _obj = Scoutui::Base::QBrowser.getFirstObject(driver, locator)
              end
            end
            next
          end
        end

        # TODO: Matt commented this out. Re-add?
        # obj = Scoutui::Base::QBrowser.getFirstObject(driver, selector)
        # Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!obj.nil?, __FILE__ + (__LINE__).to_s + " Verify #{selector} visible")
      end
    end

    def self.process_element(driver, model_key, model_node)
      element = Scoutui::Base::QBrowser.getFirstObject(driver, model_node['locator'], Scoutui::Commands::Utils.instance.getTimeout)
      raise Exception, "NOT FOUND : '#{model_key}' with selector #{model_node['locator']}".red if element.nil?

      assertion_validator = Scoutui::Assertions::Validator.new(driver)
      assertion_validator.validate(model_key, model_node)
    end
  end
end
