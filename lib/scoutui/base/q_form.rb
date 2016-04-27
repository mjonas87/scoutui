
require 'selenium-webdriver'


module Scoutui::Base


  class QForm

    attr_accessor :elements
    attr_accessor :drv

    def initialize(*p)
      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " size : #{p.size}"
      @drv=nil

      if p.size==1 && p[0].is_a?(Hash)

        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " Hash was passed"
        @elements = p[0]
      elsif p.size==1 && p[0].is_a?(String)
        # Load form from a JSON file
      elsif p.size==2
        @drv=p[0]

        @elements = p[1] if p[1].is_a?(Hash)

      end

    end

    def dump()
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " QForm.dump()"
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " => #{@elements.to_s}"
    end

    def actionElement(drv, locator)
      user_vars = Scoutui::Base::UserVars.new

      _action=nil

      obj = Scoutui::Base::QBrowser.getObject(drv, locator)
      _type = obj.attribute('type').to_s
      _tag = obj.tag_name.to_s

      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " obj => type:#{_type}  tag:#{_tag}"

      # element.getAttribute("type").equalsIgnoreCase("text")
      if !_type.match(/(password|text|email)/i).nil? && !_tag.match(/(input|textarea)/i).nil?

        _v = user_vars.get(dut[k].to_s)

        _action="send_keys"
        obj.send_keys(_v)
      elsif !_type.match(/(date|number|search|tel|time|url|week)/i).nil?
        _v = user_vars.get(dut[k].to_s)
        _action="send_keys"
        obj.send_keys(_v)
      elsif !_type.match(/(button|checkbox|radio|submit)/i).nil?
        _action="click"
        obj.click()
      else
        _action="click"
        obj.click()
      end

      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " action : #{_action}"
      _action

    end

    def submitForm(drv=nil)
      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " -- submit(#{drv.class.to_s} --"

      rc=false

      if drv.nil?
        drv=@drv
      end

      action_obj = @elements.select { |key, e| e.is_a?(Hash) && e.has_key?('action_object') && e['action_object']==true }

      if !action_obj.nil?
        # Find the submit action element
        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " -- submit => #{action_obj}"
        actionElement(drv, action_obj[action_obj.keys[0]])
        rc=true
      else
        Scoutui::Logger::LogMgr.instance.commands.warn __FILE__ + (__LINE__).to_s + " WARN: missing action object."
      end

      rc
    end


    def verifyForm(drv)
      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " verifyForm()"

      _req = Scoutui::Utils::TestUtils.instance.getReq()

      puts __FILE__ + (__LINE__).to_s + " req => #{_req}"

      @elements.each do |elt|
        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " => #{elt.to_s} : #{elt.class.to_s}"

        if elt.is_a?(Array)

            n=elt[0]
            v=elt[1]

            k='visible_when'
            if v.is_a?(Hash) && v.has_key?(k) && v.has_key?('locator')


              obj = Scoutui::Base::QBrowser.getObject(drv, v['locator'])

              if !v[k].match(/always/i).nil?
                _rc = !obj.nil? && obj.is_a?(Selenium::WebDriver::Element) && obj.displayed?
                Scoutui::Logger::LogMgr.instance.asserts.info " Verify element #{n} with locator #{v['locator']} is always visible on form - #{_rc.to_s}"
                Testmgr::TestReport.instance.getReq(_req).tc(k).add(_rc, __FILE__ + (__LINE__).to_s + " Verify element #{n} with locator #{v['locator']} is always visible on form")
              elsif !v[k].match(/([!])*title\((.*)\)/i).nil?
                _hit = v[k].match(/([!])*title\(\/(.*)\/\)/i)
                _not = _hit[1]
                _title = _hit[2]

                Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " Verify title |#{drv.title}| matches #{_title}"

                _rc = !drv.title.match(Regexp.new(_title)).nil?

                if !_not.nil?
                  _rc=!_rc
                end

                Scoutui::Logger::LogMgr.instance.asserts.info " Verify expected title matches #{_not.to_s}#{_title} for form. - #{_rc.to_s}"
                Testmgr::TestReport.instance.getReq(_req).tc(k).add(_rc, __FILE__ + (__LINE__).to_s + " Verify expected title matches #{_not.to_s}#{_title} for form.")


              elsif !v[k].match(/\s*(visible)\((.*)\)\=(.*)/).nil?
                Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " ==> #{v[k].to_s}"
                _match=v[k].match(/\s*(visible)\((.*)\)\=(.*)/)
                _cond=_match[1]
                _obj=_match[2]
                _expected_val=_match[3]

                Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " <cond, obj, when>::<#{_cond}, #{_obj}, #{_expected_val}"

                depObj = Scoutui::Base::QBrowser.getObject(drv, _obj)
                Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " hit => #{depObj.class.to_s} tag:#{depObj.tag_name}" if !depObj.nil?

                desc=nil
                if _expected_val.match(/true/i)
                  obj = Scoutui::Base::QBrowser.getObject(drv, v['locator'])

                  _rc = !depObj.nil? && depObj.displayed? && !obj.nil? && obj.displayed?
                  Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{v['locator']} is displayed since #{_obj} is displayed - #{_rc.to_s}"
                  Testmgr::TestReport.instance.getReq(_req).tc(k).add(_rc, "Verify #{v['locator']} is displayed since #{_obj} is displayed")
                elsif _expected_val.match(/false/i)
                  obj = Scoutui::Base::QBrowser.getObject(drv, v['locator'])

                  _rc =  depObj.nil? && !obj.nil? && obj.displayed?
                  Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{v['locator']} is displayed since #{_obj} is not visible. - #{_rc.to_s}"
                  Testmgr::TestReport.instance.getReq(_req).tc(k).add(_rc, "Verify #{v['locator']} is displayed since #{_obj} is not visible.")
                end

              elsif !v[k].match(/value\((.*)\)\=(.*)/).nil?
                  _match=v[k].match(/value\((.*)\)\=(.*)/)
                  _obj=_match[1]
                  _expected_val=_match[2]

                  obj = Scoutui::Base::QBrowser.getObject(drv, _obj)
                  Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " hit => #{obj.class.to_s} tag:#{obj.tag_name}"



                  if !obj.nil? && obj.is_a?(Selenium::WebDriver::Element) && obj.tag_name=='select'

                    _options=Selenium::WebDriver::Support::Select.new(obj)
                    _val = _options.first_selected_option.text

                    Testmgr::TestReport.instance.getReq(_req).tc(k).add(!_val.match(/#{_expected_val}/).nil?, __FILE__ + (__LINE__).to_s + " Verify obj #{n} displayed when #{v.to_s}")

                    if false

                      _options=obj.find_elements(:tag_name=>"option")

                      _options.each do |_o|
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " | value : #{_o.attribute('value').to_s}"
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " |        text      : #{_o.text.to_s}"
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " |        displayed : #{_o.displayed?}"
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " |        enabled   : #{_o.enabled?}"
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " |        location  : #{_o.location}"
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " |        selected  :#{_o.selected?}"
                        Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " |        methods:#{_o.methods.sort.to_s}" # ", #{_o.text.to_s}, selected: #{_o.to_s}"
                        # Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " PAUSE"; gets()
                      end
                    end

                  end
              end


            end


        end
      end
    end

    def fillForm(drv, dut)
      user_vars = Scoutui::Base::UserVars.new

      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " fillForm(#{drv.to_s}, #{dut.to_s})"
      Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " | type => #{dut.class.to_s}"

      if dut.is_a?(Hash)

        dut.keys.each do |k|
          if @elements.has_key?(k)
            _xpath = @elements[k]   # .to_s

            Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " key(#{k}) : locator:#{_xpath} => #{dut[k].to_s}"

            if !drv.nil?
              @drv=drv
              obj = Scoutui::Base::QBrowser.getObject(drv, _xpath)

              _type = obj.attribute('type').to_s
              _tag = obj.tag_name.to_s

              Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " obj => type:#{_type}  tag:#{_tag}"

              # element.getAttribute("type").equalsIgnoreCase("text")
              if !_type.match(/(password|text|email)/i).nil? && !_tag.match(/(input|textarea)/i).nil?
                _v = user_vars.get(dut[k].to_s)
                obj.send_keys(_v)

              elsif _type.match(/(select)/i)
                _v = user_vars.get(dut[k].to_s)
                _opt = Selenium::WebDriver::Support::Select.new(obj)
                _opt.select_by(:text, user_vars.get(_v))
              else
                Scoutui::Logger::LogMgr.instance.commands.warn " Unidentified attribute type : #{_type.to_s}"
              end
            end

          else
            Scoutui::Logger::LogMgr.instance.commands.debug __FILE__ + (__LINE__).to_s + " ** key #{k} not part of form **"
          end

        end

      end


      self

    end



  end

end
