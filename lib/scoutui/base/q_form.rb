
require 'selenium-webdriver'


module Scoutui::Base


  class QForm

    attr_accessor :elements
    attr_accessor :drv

    def initialize(*p)
      puts __FILE__ + (__LINE__).to_s + " size : #{p.size}"
      @drv=nil

      if p.size==1 && p[0].is_a?(Hash)

        puts __FILE__ + (__LINE__).to_s + " Hash was passed"
        @elements = p[0]
      elsif p.size==1 && p[0].is_a?(String)
        # Load form from a JSON file
      elsif p.size==2
        @drv=p[0]

        @elements = p[1] if p[1].is_a?(Hash)

      end

    end

    def dump()
      puts __FILE__ + (__LINE__).to_s + " QForm.dump()"
      puts __FILE__ + (__LINE__).to_s + " => #{@elements.to_s}"
    end

    def actionElement(drv, locator)

      obj = Scoutui::Base::QBrowser.getObject(drv, locator)
      _type = obj.attribute('type').to_s
      _tag = obj.tag_name.to_s

      puts __FILE__ + (__LINE__).to_s + " obj => type:#{_type}  tag:#{_tag}"

      # element.getAttribute("type").equalsIgnoreCase("text")
      if !_type.match(/(password|text|email)/i).nil? && !_tag.match(/(input|textarea)/i).nil?

        _v = Scoutui::Base::UserVars.instance.get(dut[k].to_s)

        obj.send_keys(_v)
      elsif !_type.match(/(date|number|search|tel|time|url|week)/i).nil?
        _v = Scoutui::Base::UserVars.instance.get(dut[k].to_s)
        obj.send_keys(_v)
      elsif !_type.match(/(button|checkbox|radio|submit)/i).nil?
        obj.click()
      else
        obj.click()
      end

    end

    def submitForm(drv=nil)
      puts __FILE__ + (__LINE__).to_s + " -- submit(#{drv.class.to_s} --"
      if drv.nil?
        drv=@drv
      end

      action_obj = @elements.select { |key, e| e.is_a?(Hash) && e.has_key?('action_object') && e['action_object']==true }
      # Find the submit action element
      puts __FILE__ + (__LINE__).to_s + " -- submit => #{action_obj}"
      actionElement(drv, action_obj[action_obj.keys[0]])
    end


    def verifyForm(drv)
      puts __FILE__ + (__LINE__).to_s + " verifyForm()"
      @elements.each do |elt|
        puts __FILE__ + (__LINE__).to_s + " => #{elt.to_s} : #{elt.class.to_s}"

        if elt.is_a?(Array)

            n=elt[0]
            v=elt[1]

            k='visible_when'
            if v.is_a?(Hash) && v.has_key?(k) && v.has_key?('locator')


              obj = Scoutui::Base::QBrowser.getObject(drv, v['locator'])

              if !v[k].match(/always/i).nil?
                Testmgr::TestReport.instance.getReq('UI').tc(k).add(!obj.nil? && obj.is_a?(Selenium::WebDriver::Element) && obj.displayed?, __FILE__ + (__LINE__).to_s + " Verify element #{n} with locator #{v['locator']} is always visible on form")
              elsif !v[k].match(/([!])*title\((.*)\)/i).nil?
                _hit = v[k].match(/([!])*title\(\/(.*)\/\)/i)
                _not = _hit[1]
                _title = _hit[2]

                puts __FILE__ + (__LINE__).to_s + " Verify title |#{drv.title}| matches #{_title}"

                _rc = !drv.title.match(Regexp.new(_title)).nil?

                if !_not.nil?
                  _rc=!_rc
                end

                Testmgr::TestReport.instance.getReq('UI').tc(k).add(_rc, __FILE__ + (__LINE__).to_s + " Verify expected title matches #{_not.to_s}#{_title} for form.")


              elsif !v[k].match(/\s*(visible)\((.*)\)\=(.*)/).nil?
                puts __FILE__ + (__LINE__).to_s + " ==> #{v[k].to_s}"
                _match=v[k].match(/\s*(visible)\((.*)\)\=(.*)/)
                _cond=_match[1]
                _obj=_match[2]
                _expected_val=_match[3]

                puts __FILE__ + (__LINE__).to_s + " <cond, obj, when>::<#{_cond}, #{_obj}, #{_expected_val}"

                depObj = Scoutui::Base::QBrowser.getObject(drv, _obj)
                puts __FILE__ + (__LINE__).to_s + " hit => #{depObj.class.to_s} tag:#{depObj.tag_name}" if !depObj.nil?

                desc=nil
                if _expected_val.match(/true/i)
                  obj = Scoutui::Base::QBrowser.getObject(drv, v['locator'])
                  Testmgr::TestReport.instance.getReq('UI').tc(k).add(!depObj.nil? && depObj.displayed? && !obj.nil? && obj.displayed?, "Verify #{v['locator']} is displayed since #{_obj} is displayed")
                elsif _expected_val.match(/false/i)
                  obj = Scoutui::Base::QBrowser.getObject(drv, v['locator'])
                  Testmgr::TestReport.instance.getReq('UI').tc(k).add( depObj.nil? && !obj.nil? && obj.displayed?, "Verify #{v['locator']} is displayed since #{_obj} is not visible.")
                end

              elsif !v[k].match(/value\((.*)\)\=(.*)/).nil?
                  _match=v[k].match(/value\((.*)\)\=(.*)/)
                  _obj=_match[1]
                  _expected_val=_match[2]

                  obj = Scoutui::Base::QBrowser.getObject(drv, _obj)
                  puts __FILE__ + (__LINE__).to_s + " hit => #{obj.class.to_s} tag:#{obj.tag_name}"



                  if !obj.nil? && obj.is_a?(Selenium::WebDriver::Element) && obj.tag_name=='select'

                    _options=Selenium::WebDriver::Support::Select.new(obj)
                    _val = _options.first_selected_option.text

                    Testmgr::TestReport.instance.getReq('UI').tc(k).add(!_val.match(/#{_expected_val}/).nil?, __FILE__ + (__LINE__).to_s + " Verify obj #{n} displayed when #{v.to_s}")

                    if false

                      _options=obj.find_elements(:tag_name=>"option")

                      _options.each do |_o|
                        puts __FILE__ + (__LINE__).to_s + " | value : #{_o.attribute('value').to_s}"
                        puts __FILE__ + (__LINE__).to_s + " |        text      : #{_o.text.to_s}"
                        puts __FILE__ + (__LINE__).to_s + " |        displayed : #{_o.displayed?}"
                        puts __FILE__ + (__LINE__).to_s + " |        enabled   : #{_o.enabled?}"
                        puts __FILE__ + (__LINE__).to_s + " |        location  : #{_o.location}"
                        puts __FILE__ + (__LINE__).to_s + " |        selected  :#{_o.selected?}"
                        puts __FILE__ + (__LINE__).to_s + " |        methods:#{_o.methods.sort.to_s}" # ", #{_o.text.to_s}, selected: #{_o.to_s}"
                        # puts __FILE__ + (__LINE__).to_s + " PAUSE"; gets()
                      end
                    end

                  end
              end


            end


        end
      end
    end

    def fillForm(drv, dut)

      puts __FILE__ + (__LINE__).to_s + " fillForm(#{drv.to_s}, #{dut.to_s})"
      puts __FILE__ + (__LINE__).to_s + " | type => #{dut.class.to_s}"

      if dut.is_a?(Hash)

        dut.keys.each do |k|
          if @elements.has_key?(k)
            _xpath = @elements[k]   # .to_s

            puts __FILE__ + (__LINE__).to_s + " key(#{k}) : locator:#{_xpath} => #{dut[k].to_s}"

            if !drv.nil?
              @drv=drv
              obj = Scoutui::Base::QBrowser.getObject(drv, _xpath)

              _type = obj.attribute('type').to_s
              _tag = obj.tag_name.to_s

              puts __FILE__ + (__LINE__).to_s + " obj => type:#{_type}  tag:#{_tag}"

              # element.getAttribute("type").equalsIgnoreCase("text")
              if !_type.match(/(password|text|email)/i).nil? && !_tag.match(/(input|textarea)/i).nil?
                _v = Scoutui::Base::UserVars.instance.get(dut[k].to_s)
                obj.send_keys(_v)

              elsif _type.match(/(select)/i)
                _v = Scoutui::Base::UserVars.instance.get(dut[k].to_s)
                _opt = Selenium::WebDriver::Support::Select.new(obj)
                _opt.select_by(:text, Scoutui::Base::UserVars.instance.get(_v))
              end
            end

          else
            puts __FILE__ + (__LINE__).to_s + " ** key #{k} not part of form **"
          end

        end

      end


      self

    end



  end

end
