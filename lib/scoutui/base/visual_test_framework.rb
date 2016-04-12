#require 'testmgr'

module Scoutui::Base

  class VisualTestFramework

    STEP_KEY='page'
    CMD_KEY='dut'   # Used to indicate the command file (YML) to execute

    def initialize()

    end


    def self.processPageElement(my_driver, k, xpath)
      processed=false
      _obj=nil

      if !xpath.match(/^\s*page\(.*\)\s*$/).nil?

        processed=true

        # Check if this is a form

        page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)

        Scoutui::Logger::LogMgr.instance.info "Locate Element: #{page_elt}".blue

        sub_elts=0
        if page_elt.is_a?(Hash)
          sub_elts = page_elt.select { |_s| page_elt[_s].has_key?("locator") if page_elt[_s].is_a?(Hash) &&  !page_elt[_s].nil?  }.size
        end

        if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

          ##
          # expected:
          #   wait: page(abc).get(def)    where this page_elt has "locator"

          xpath = page_elt['locator'].to_s
          _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, xpath)
          _req = nil

          if page_elt.has_key?('reqid')
            _req=page_elt['reqid'].to_s
          end

          Scoutui::Base::Assertions.instance.assertPageElement(k, page_elt, _obj, my_driver, _req)
        elsif sub_elts > 0
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Validate form"
          page_elt.each_pair do |_k, _v|

            begin

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}  (#{_v.class.to_s})"

              _obj=nil

              if _v.is_a?(Array)
                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Arrays - TBD => #{_v}"
              end


              if _v.is_a?(String)
                puts __FILE__ + (__LINE__).to_s + " #{_v} is a string - next"
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

              _req = nil

              if _v.has_key?('reqid')
                _req=_v['reqid'].to_s
              end

              if _v.has_key?('locator')
                _locator = _v['locator'].to_s
                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

                #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

                _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator, Scoutui::Commands::Utils.instance.getTimeout())

                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{(!_obj.nil?).to_s}"  # if Scoutui::Utils::TestUtils.instance.isDebug?
              end

              if Scoutui::Base::Assertions.instance.visible_when_always(_k, _v, _obj, _req)
                next
              elsif Scoutui::Base::Assertions.instance.visible_when_never(_k, _v, _obj, _req)
                next
              elsif Scoutui::Base::Assertions.instance.visible_when_title(_k, _v, _obj, my_driver, _req)
                next
              elsif Scoutui::Base::Assertions.instance.visible_when_value(_k, _v, my_driver, _req)
                next
              elsif _v.has_key?('visible_when') && !_v['visible_when'].is_a?(Array)

                if _v['visible_when'].match(/role\=/i)
                  _role = _v['visible_when'].match(/role\=(.*)/i)[1].to_s
                  _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

                  Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists if the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

                  if _role==_expected_role.to_s
                    Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} #{_locator}  visible when role #{_role} - #{!_obj.nil?.to_s}"
                    Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify #{_k} #{_locator}  visible when role #{_role}")
                  end

                end
              elsif _v.has_key?('visible_when') && _v['visible_when'].is_a?(Array)
                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " visible_when : (Array) - TBD  #{_v['visible_when']}"

                _v['visible_when'].each do |_vwhen|
                  puts __FILE__ + (__LINE__).to_s + " #{_vwhen}  #{_vwhen.class}"

                  Scoutui::Base::Assertions.instance.assertPageElement(_k, _vwhen, _obj, my_driver, _req)


                end
              end


            rescue => ex
              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Error during processing: #{ex}"
              puts __FILE__ + (__LINE__).to_s +  "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
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

          # next
        end


      end

      _obj

    end


    def self.processCommand(_action, e, my_driver)
      _req = Scoutui::Utils::TestUtils.instance.getReq()
      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " ===  Process ACTION : #{_action}  ==="  if Scoutui::Utils::TestUtils.instance.isDebug?

      if Scoutui::Commands::Utils.instance.isExistsAlert?(_action)
        _c = Scoutui::Commands::JsAlert::ExistsAlert.new(_action)
        _rc = _c.execute(my_driver)
        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " existsAlert => #{_rc}"

        Scoutui::Logger::LogMgr.instance.asserts.info "Verify alert is present - #{!_rc.nil?.to_s}"
        Testmgr::TestReport.instance.getReq(_req).get_child('expectJsAlert').add(!_rc.nil?, "Verify alert is present")

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
          Scoutui::Logger::LogMgr.instance.commands.info "send_keys(#{_val})"
          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
        else
          Scoutui::Logger::LogMgr.instance.warn __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
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
      Scoutui::Logger::LogMgr.instance.info 'Process Assertions'.yellow

      if !e[STEP_KEY].has_key?('assertions')
        return
      end

      if !e[STEP_KEY]['assertions'].is_a?(Array)
        Scoutui::Logger::LogMgr.instance.warn __FILE__ + (__LINE__).to_s + " \'assertions\' field must be type Array."
        return
      end

      _req = Scoutui::Utils::TestUtils.instance.getReq()

      puts __FILE__ + (__LINE__).to_s + "======= #{e[STEP_KEY]['assertions']} ========="


      e[STEP_KEY]['assertions'].each do |elt|

        begin


        _k = elt.keys[0].to_s
        a = elt[_k]

        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Assert => #{_k} :  #{a.to_s}"

    #    _k = 'generic-assertion'
        _v={}

        if a.is_a?(Hash)
          _v=a


          if _v.has_key?('reqid')
            _req = _v['reqid']
          end

          if _v.has_key?('locator')
            _locator = _v['locator'].to_s

            if !_locator.match(/^page\([\w\d]+\)/).nil?
              _obj = processPageElement(my_driver, _k, _locator)
              puts __FILE__ + (__LINE__).to_s + " Processed #{_locator} => #{_obj.class.to_s}"
            else

              Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

              #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

              _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator, Scoutui::Commands::Utils.instance.getTimeout())

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}" if Scoutui::Utils::TestUtils.instance.isDebug?
            end

          end

          if _v.has_key?('visible_when')

            if _v['visible_when'].match(/always/i)
              Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + " Verify assertion #{_k} - #{_locator} visible - #{!_obj.nil?.to_s}"
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify assertion #{_k} - #{_locator} visible")
            elsif Scoutui::Base::Assertions.instance.visible_when_never(_k, _v, _obj, _req)
              ;
            elsif _v['visible_when'].match(/role\=/i)
              _role = _v['visible_when'].match(/role\=(.*)/i)[1].to_s
              _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

              Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify assertion object exists if the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

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
          puts __FILE__ + (__LINE__).to_s +  "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
        end
      end
    end


    def self.processExpected(my_driver, e)

      _req = Scoutui::Utils::TestUtils.instance.getReq()

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
            # Check if the verification is a "windows.*" verification

            if !xpath.match(/window[s]\.length\s*\(\d+\)/).nil?
              _expected_length=xpath.match(/window[s]\.length\s*\((.*)\)/i)[1].to_s

              Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + "\tExpect window.length is #{_expected_length}"

              if _expected_length =~ /\A\d+\z/
                # 5150
                totalWindows = my_driver.window_handles.length

                if Scoutui::Utils::TestUtils.instance.assertExpected?
                  Testmgr::TestReport.instance.getReq(_req).get_child('window_size').add(totalWindows==_expected_length.to_i, "Verify number of windows is #{_expected_length}  actual(#{totalWindows})")
                end

              end

              next
            end


            if !xpath.match(/\$\{.*\}/).nil?
          #    xpath = Scoutui::Base::UserVars.instance.get(xpath)
              xpath = Scoutui::Base::UserVars.instance.normalize(xpath)
            end


            if !xpath.match(/^page\([\w\d]+\)/).nil?


              # Check if this is a form

              page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)

              sub_elts=0
              if page_elt.is_a?(Hash)
                sub_elts = page_elt.select { |_s| page_elt[_s].has_key?("locator") if page_elt[_s].is_a?(Hash) &&  !page_elt[_s].nil?  }.size
              end

              if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

                ##
                # expected:
                #   wait: page(abc).get(def)    where this page_elt has "locator"

                xpath = page_elt['locator'].to_s

              elsif sub_elts > 0
                Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Validate form" if Scoutui::Utils::TestUtils.instance.isDebug?

                page_elt.each_pair do |_k, _v|

                  begin

                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}  (#{_v.class.to_s})" if Scoutui::Utils::TestUtils.instance.isDebug?

                    _obj=nil


                    if _v.is_a?(String)
                      puts __FILE__ + (__LINE__).to_s + " #{_v} is a string - next"
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

                      _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator, Scoutui::Commands::Utils.instance.getTimeout())

                      Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}" if Scoutui::Utils::TestUtils.instance.isDebug?
                    end

                    if Scoutui::Base::Assertions.instance.visible_when_always(_k, _v, _obj)
                      next
                    elsif _v.has_key?('visible_when')

                      if _v['visible_when'].match(/always/i)
                        Scoutui::Logger::LogMgr.instance.asserts.info __FILE__ + (__LINE__).to_s + " Verify #{_k} - #{_locator} visible - #{!_obj.nil?.to_s}"

                        if Scoutui::Utils::TestUtils.instance.assertExpected?
                          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify #{_k} - #{_locator} visible")
                        end

                      elsif _v['visible_when'].match(/never/i)
                        Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} #{_locator} never visible - #{obj.nil?.to_s}"

                        if Scoutui::Utils::TestUtils.instance.assertExpected?
                          Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(obj.nil?, "Verify #{_k} #{_locator} not visible")
                        end

                      elsif _v['visible_when'].match(/role\=/i)
                        _role = _v['visible_when'].match(/role\=(.*)/i)[1].to_s
                        _expected_role = Scoutui::Utils::TestUtils.instance.getRole()

                        Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Verify object exists if the role #{_role} matches expected role #{_expected_role.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

                        if _role==_expected_role.to_s
                          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_k} #{_locator}  visible when role #{_role} - #{!_obj.nil?.to_s}"

                          if Scoutui::Utils::TestUtils.instance.assertExpected?
                            Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!_obj.nil?, "Verify #{_k} #{_locator}  visible when role #{_role}")
                          end

                        end

                      end
                    end


                  rescue => ex
                    Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Invalid file: #{datafile} - abort processing."
                    puts __FILE__ + (__LINE__).to_s +  "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
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

            if Scoutui::Utils::TestUtils.instance.assertExpected?
              Testmgr::TestReport.instance.getReq(_req).get_child('visible_when').add(!obj.nil?, __FILE__ + (__LINE__).to_s + " Verify #{xpath} visible")
            end

            raise Exception, "NOT FOUND : #{link_name} with xpath #{xpath}".red if obj.nil?
          end
        end
      end
    end

    # Scoutui::Base::VisualTestFramework.processFile(@drv, @eyes, @test_settings['host'], @test_settings['dut'])
    def self.processFile(eyeScout, test_settings, strategy=nil)
      my_driver = eyeScout.drv()

      baseUrl = Scoutui::Base::UserVars.instance.getHost()
      datafile = test_settings['dut']

      valid_file=false
      i=0
      begin
        dut_dupes = YAML.load_stream File.read(datafile)
        valid_file=true
      rescue => ex
        Scoutui::Logger::LogMgr.instance.fatal __FILE__ + (__LINE__).to_s + " Invalid file: #{datafile} - abort processing."
        Scoutui::Logger::LogMgr.instance.info ex.backtrace
      end

      return if !valid_file

      dut_dupes.each do |e|

        totalWindows = my_driver.window_handles.length

        ap(e)
        i += 1

        Scoutui::Utils::TestUtils.instance.setReq('UI')
        Scoutui::Commands::Utils.instance.resetTimeout()

        _action = e[STEP_KEY]["action"]
        _name   = e[STEP_KEY]["name"]
        _url    = e[STEP_KEY]["url"]
        _skip   = e[STEP_KEY]["skip"]
        _region = e[STEP_KEY]["region"]
        _reqid  = e[STEP_KEY]["reqid"]

        if e[STEP_KEY].has_key?("timeout")
         Scoutui::Commands::Utils.instance.setTimeout(e[STEP_KEY]["timeout"])
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


        if !isRun(e).nil?

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " ========> RUN <================="
          tmpSettings=test_settings.dup
          tmpSettings["dut"]=e[STEP_KEY]["run"].to_s

          Scoutui::Logger::LogMgr.instance.info " RUN Command file : #{tmpSettings["dut"]}"
          processFile(eyeScout, tmpSettings, strategy)
          Scoutui::Logger::LogMgr.instance.info __FILE__ + (__LINE__).to_s + " Completed execution of subfile"
          next

        end

        if !(_action.nil? || _action.to_s.empty?)

       #  if !Scoutui::Commands::processCommand(_action, e, my_driver)

          Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_action} is valid - #{Scoutui::Commands::Utils.instance.isValid?(_action).to_s}"
          Testmgr::TestReport.instance.getReq('Command').get_child('isValid').add(Scoutui::Commands::Utils.instance.isValid?(_action), "Verify #{_action} is valid")

          begin


            _command = eyeScout.getStrategy().processCommand(_action, e)

            if my_driver.window_handles.length > totalWindows
              Scoutui::Logger::LogMgr.instance.info "[post-cmd] Total Windows : #{my_driver.window_handles.length.to_s}"
            end


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

          rescue => ex
            "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
          end

          next
        end


        if e[STEP_KEY].has_key?("url")
          url = e[STEP_KEY]["url"].to_s
          eyeScout.getStrategy().processCommand('navigate(' + url + ')', e)
        end

        processExpected(my_driver, e)
        processAssertions(my_driver, e)

         if !_region.nil?
          eyeScount.check_window(_name, _region)
        else
          eyeScout.check_window(_name)
        end


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
