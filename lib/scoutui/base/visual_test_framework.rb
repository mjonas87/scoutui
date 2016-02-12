#require 'testmgr'

module Scoutui::Base

  class VisualTestFramework

    STEP_KEY='page'

    def initialize()

    end


    def self.processCommand(_action, e, my_driver)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " ===  Process ACTION : #{_action}  ==="  if Scoutui::Utils::TestUtils.instance.isDebug?

      if Scoutui::Commands::Utils.instance.isExistsAlert?(_action)
        _c = Scoutui::Commands::JsAlert::ExistsAlert.new(_action)
        _rc = _c.execute(my_driver)
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " existsAlert => #{_rc}"

        Scoutui::Logger::LogMgr.instance.info "Verify alert is present - #{!_rc.nil?.to_s}"
        Testmgr::TestReport.instance.getReq('UI').get_child('expectJsAlert').add(!_rc.nil?, "Verify alert is present")

      elsif Scoutui::Commands::Utils.instance.isVerifyForm?(_action)
        _c = Scoutui::Commands::VerifyForm.new(_action)
        _c.execute(my_driver)

      elsif !_action.match(/fillform\(/).nil? && false

     #   _c = Scoutui::Commands::FillForm.new(_action)

        _form = _action.match(/fillform\((.*)\s*\)/)[1].to_s
     #  _dut = _action.match(/fillform\(.*,\s*(.*)\)/)[1].to_s

        dut = e[STEP_KEY]['dut']

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " DUT => #{dut}" if Scoutui::Utils::TestUtils.instance.isDebug?
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.dump()
        _f.verifyForm(my_driver)
        _f.fillForm(my_driver, dut)

      elsif !_action.match(/submitform\(/).nil? && false
        _cmd = Scoutui::Commands::SubmitForm.new(_action)
     #   _cmd.execute(my_driver)

        _form = _action.match(/submitform\((.*)\s*\)/)[1].to_s
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.submitForm(my_driver)

      elsif !_action.match(/type\(/).nil?  && false
        _xpath = _action.match(/type\((.*),\s*/)[1].to_s
        _val   = _action.match(/type\(.*,\s*(.*)\)/)[1].to_s

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)

        if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password|email)/).nil?
          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
        else
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
        end

      end


    end

    def self.isRun(e)
      _run=nil
      if e[STEP_KEY].has_key?("run")
        _run = e[STEP_KEY].has_key?("run").to_s
      end
      _run
    end

    def self.isSnapIt(e)
      _snapit=false

      if e[STEP_KEY].has_key?("snapit")
        _snapit = !(e[STEP_KEY]["snapit"].to_s.match(/true/i).nil?)
      end
      _snapit
    end


    def self.verifyCondition(my_driver, xpath)
      rc=false

      if !xpath.match(/^page\([\w\d]+\)/).nil?

        page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Process page request #{page_elt} => #{page_elt.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

          ##
          # expected:
          #   wait: page(abc).get(def)    where this page_elt has "locator"

          xpath = page_elt['locator'].to_s

        elsif xpath.is_a?(Hash)
          xpath.each_pair do |_k, _v|

            Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}"

            if _v.has_key?('locator')
              _locator = _v['locator'].to_s
              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

              #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

              _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator)

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}"
            end

          end


        end

      end

    end


    def self.processAssertions(my_driver, e)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " === ProcessAssertions(#{e.to_s} ====" if Scoutui::Utils::TestUtils.instance.isDebug?

      if !e[STEP_KEY].has_key?('assertions')
        return
      end

      e[STEP_KEY]['assertions'].each do |a|
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Assert => #{a.to_s}"
      end


    end


    def self.processExpected(my_driver, e)
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + "\to Expected:  #{e[STEP_KEY]['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      Scoutui::Base::Assertions.instance.setDriver(my_driver)

      if e[STEP_KEY].has_key?('expected')
        expected_list=e[STEP_KEY]['expected']


        if expected_list.is_a?(Array)
          expected_list.each do |_condition|
            verifyCondition(my_driver, _condition)
          end
        end

        if expected_list.is_a?(Hash)

          expected_list.each_pair do |link_name, xpath|

            Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s +  "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

            if !xpath.match(/\$\{.*\}/).nil?
              xpath = Scoutui::Base::UserVars.instance.get(xpath)
            end


            if !xpath.match(/^page\([\w\d]+\)/).nil?


              # Check if this is a form


              page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)
              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Process page request #{page_elt} => #{page_elt.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

              sub_elts=0
              if page_elt.is_a?(Hash)
                sub_elts = page_elt.select { |_s| page_elt[_s].has_key?("locator") if page_elt[_s].is_a?(Hash) &&  !page_elt[_s].nil?  }.size
              end

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " SubElts => #{sub_elts}" if Scoutui::Utils::TestUtils.instance.isDebug?




              if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

                ##
                # expected:
                #   wait: page(abc).get(def)    where this page_elt has "locator"

                xpath = page_elt['locator'].to_s

              elsif sub_elts > 0
                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Validate form" if Scoutui::Utils::TestUtils.instance.isDebug?

                page_elt.each_pair do |_k, _v|
                  Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}  (#{_v.class.to_s})" if Scoutui::Utils::TestUtils.instance.isDebug?

                  _obj=nil

                  if _v.is_a?(String)
                    next
                  end

                  if _v.has_key?('assert_when') && _v['assert_when'].match(/role\s*\=/i)
                    _role = _v['assert_when'].match(/role\s*\=(.*)/i)[1].to_s
                    _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Trigger: expected : #{_expected_role.to_s}, actual: #{_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

                    if !_expected_role.nil? && !_role.match(/#{_expected_role}/i)
                      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Skip assertion since conditional assertion #{_v['assert_when']} not met" if Scoutui::Utils::TestUtils.instance.isDebug?
                      next
                    elsif _expected_role.nil?
                      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Skip role based assertion since role was not provided" if Scoutui::Utils::TestUtils.instance.isDebug?
                      next
                    end
                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists since the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
                  end


                  if Scoutui::Base::Assertions.instance.visible_when_skip(_k, _v)
                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " SKIP #{_k.to_s} - #{_v.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
                    next
                  end

                  if _v.has_key?('locator')
                    _locator = _v['locator'].to_s
                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator if Scoutui::Utils::TestUtils.instance.isDebug?

                    #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

                    _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator)

                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}" if Scoutui::Utils::TestUtils.instance.isDebug?
                  end

                  if Scoutui::Base::Assertions.instance.visible_when_always(_k, _v, _obj)
                    next
                  elsif _v.has_key?('visible_when')

                    if _v['visible_when'].match(/always/i)
                      Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + " Verify #{_k} - #{_locator} visible - #{!_obj.nil?.to_s}"
                      Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(!_obj.nil?, "Verify #{_k} - #{_locator} visible")
                    elsif _v['visible_when'].match(/never/i)
                      Scoutui::Logger::LogMgr.instance.info "Verify #{_k} #{_locator} not visible - #{obj.nil?.to_s}"
                      Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(obj.nil?, "Verify #{_k} #{_locator} not visible")
                    elsif _v['visible_when'].match(/role\=/i)
                      _role = _v['visible_when'].match(/role\=(.*)/i)[1].to_s
                      _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

                      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists if the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

                      if _role==_expected_role.to_s
                        Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} #{_locator}  visible when role #{_role} - #{!_obj.nil?.to_s}"
                        Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(!_obj.nil?, "Verify #{_k} #{_locator}  visible when role #{_role}")
                      end

                    end
                  end

                end

                return


              elsif xpath.is_a?(Hash)
                xpath.each_pair do |_k, _v|

                  Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

                  if _v.has_key?('locator')
                    _locator = _v['locator'].to_s
                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator if Scoutui::Utils::TestUtils.instance.isDebug?

                  #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

                    _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator)

                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}" if Scoutui::Utils::TestUtils.instance.isDebug?
                  end

                end

                next
              end


            end

          obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, xpath)

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " obj : #{obj}"

          Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + " Verify #{xpath} visible - #{obj.kind_of?(Selenium::WebDriver::Element).to_s}"

          Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(!obj.nil?, __FILE__ + (__LINE__).to_s + " Verify #{xpath} visible")

          if obj.nil?
            Scoutui::Logger::LogMgr.instance.warn " NOT FOUND : #{link_name} with xpath #{xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?
          else
            Scoutui::Logger::LogMgr.instance.warn " link object(#{link_name} with xpath #{xpath}=> #{obj.displayed?}"  if Scoutui::Utils::TestUtils.instance.isDebug?
          end

        end
        end
      end

    end

    # Scoutui::Base::VisualTestFramework.processFile(@drv, @eyes, @test_settings['host'], @test_settings['dut'])
    def self.processFile(eyeScout, test_settings, strategy=nil)

      my_driver = eyeScout.drv()

      baseUrl = Scoutui::Base::UserVars.instance.getHost()
      datafile = test_settings['dut']

      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " processFile(#{eyeScout}, #{baseUrl}, #{datafile})" if Scoutui::Utils::TestUtils.instance.isDebug?

      valid_file=false
      i=0
      begin
        dut_dupes = YAML.load_stream File.read(datafile)
        valid_file=true
      rescue => ex
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Invalid file: #{datafile} - abort processing."
        Scoutui::Logger::LogMgr.instance.info ex.backtrace
      end

      return if !valid_file

      dut_dupes.each do |e|
        Scoutui::Logger::LogMgr.instance.info '-' * 72 if Scoutui::Utils::TestUtils.instance.isDebug?
        Scoutui::Logger::LogMgr.instance.info "#{i.to_s}. Processing #{e.inspect}" if Scoutui::Utils::TestUtils.instance.isDebug?
        i+=1

        _action = e[STEP_KEY]["action"]
        _name   = e[STEP_KEY]["name"]
        _url    = e[STEP_KEY]["url"]
        _skip   = e[STEP_KEY]["skip"]
        _region = e[STEP_KEY]["region"]

        if Scoutui::Utils::TestUtils.instance.isDebug?
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " action: #{_action}"
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " name: #{_name}"
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " url : #{_url}"
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " skip: #{_skip}"
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " region: #{_region}"
        end

        skipIt = (!_skip.nil?) && (_skip.to_s.strip.downcase=='true')
        Scoutui::Logger::LogMgr.instance.info "\to skip : #{skipIt}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if skipIt
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " SKIP - #{_name}" if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end


        if !isRun(e).nil?

          tmpSettings=test_settings.dup
          tmpSettings["dut"]=e[STEP_KEY]["run"].to_s

          processFile(eyeScout, tmpSettings)
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Completed execution of subfile"  if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end

        if !(_action.nil? || _action.empty?)

       #  if !Scoutui::Commands::processCommand(_action, e, my_driver)

          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_action} is valid - #{Scoutui::Commands::Utils.instance.isValid?(_action).to_s}"
          Testmgr::TestReport.instance.getReq('Command').get_child('isValid').add(Scoutui::Commands::Utils.instance.isValid?(_action), "Verify #{_action} is valid")



          _command = eyeScout.getStrategy().processCommand(_action, e)


        #  if !eyeScout.getStrategy().processCommand(_action, e)
          if !_command.wasExecuted?
            processCommand(_action, e, my_driver)
          end

          processExpected(my_driver, e)
          processAssertions(my_driver, e)

          if isSnapIt(e)
            if !_region.nil?
              eyeScout.check_window(_name, _region)
            else
              eyeScout.check_window(_name)
            end

          end

          next
        end


        if e[STEP_KEY].has_key?("url")
          url = e[STEP_KEY]["url"].to_s


          eyeScout.getStrategy().processCommand('navigate(' + url + ')', e)
        end


        Scoutui::Logger::LogMgr.instance.info "\to Expected:  #{e[STEP_KEY]['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        processExpected(my_driver, e)
        processAssertions(my_driver, e)

         if !_region.nil?
          eyeScount.check_window(_name, _region)
        else
          eyeScout.check_window(_name)
        end

        Scoutui::Logger::LogMgr.instance.info "\to links : #{e[STEP_KEY]['links'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        if e[STEP_KEY].has_key?('links')
          links=e[STEP_KEY]['links']

          links.each_pair do |link_name, xpath|
            Scoutui::Logger::LogMgr.instance.info "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?


            obj = QBrowser.getObject(my_driver, xpath)
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

  end


end
