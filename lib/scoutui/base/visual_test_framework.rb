#require 'testmgr'

module Scoutui::Base

  class VisualTestFramework

    STEP_KEY='page'

    def initialize()

    end


    def self.processCommand(_action, e, my_driver)
      puts __FILE__ + (__LINE__).to_s + " ===  Process ACTION : #{_action}  ==="  if Scoutui::Utils::TestUtils.instance.isDebug?

      if !_action.match(/pause/i).nil?

        _c = Scoutui::Commands::Pause.new(nil)
        _c.execute();

      elsif !_action.match(/fillform\(/).nil?

     #   _c = Scoutui::Commands::FillForm.new(_action)

        _form = _action.match(/fillform\((.*)\s*\)/)[1].to_s
     #  _dut = _action.match(/fillform\(.*,\s*(.*)\)/)[1].to_s

        dut = e[STEP_KEY]['dut']

        puts __FILE__ + (__LINE__).to_s + " DUT => #{dut}"
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.dump()
        _f.verifyForm(my_driver)
        _f.fillForm(my_driver, dut)

      elsif !_action.match(/submitform\(/).nil?
        _cmd = Scoutui::Commands::SubmitForm.new(_action)
     #   _cmd.execute(my_driver)

        _form = _action.match(/submitform\((.*)\s*\)/)[1].to_s
        _f = Scoutui::Utils::TestUtils.instance.getForm(_form)
        _f.submitForm(my_driver)

      elsif !_action.match(/type\(/).nil?
        _xpath = _action.match(/type\((.*),\s*/)[1].to_s
        _val   = _action.match(/type\(.*,\s*(.*)\)/)[1].to_s

        puts __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)

        if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password)|email/).nil?
          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
        else
          puts __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
        end

      end

    #  if !_action.match(/click\(/).nil?

      if Scoutui::Commands::Utils.instance.isClick?(_action)

    #  if Scoutui::Commands::isClick?(_action)
        _clickCmd = Scoutui::Commands::ClickObject.new(_action)
        _clickCmd.execute(my_driver)


        # _xpath = _action.match(/click\s*\((.*)\)/)[1].to_s.strip
        # puts __FILE__ + (__LINE__).to_s + " click => #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?
        #
        # _xpath = Scoutui::Base::UserVars.instance.get(_xpath)
        #
        # puts __FILE__ + (__LINE__).to_s + " | translate : #{_xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?
        #
        # obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)
        # obj.click if obj


    #  elsif isMouseOver(_action)

      elsif  Scoutui::Commands::Utils.instance.isMouseOver?(_action)

        _moCmd = Scoutui::Commands::MouseOver.new(_action)
        _moCmd.execute(my_driver)

   #     _c = Scoutui::Commands::MouseOver.new(_action)
   #     _xpath = _action.match(/mouseover\s*\((.*)\)/)[1].to_s.strip
   #     obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)
   #     my_driver.action.move_to(obj).perform

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

        puts __FILE__ + (__LINE__).to_s + " Process page request #{page_elt} => #{page_elt.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

          ##
          # expected:
          #   wait: page(abc).get(def)    where this page_elt has "locator"

          xpath = page_elt['locator'].to_s

        elsif xpath.is_a?(Hash)
          xpath.each_pair do |_k, _v|

            puts __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}"

            if _v.has_key?('locator')
              _locator = _v['locator'].to_s
              puts __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

              #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

              _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator)

              puts __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}"
            end

          end


        end

      end

    end


    def self.processAssertions(my_driver, e)
      puts __FILE__ + (__LINE__).to_s + " === ProcessAssertions(#{e.to_s} ====" if Scoutui::Utils::TestUtils.instance.isDebug?

      if !e[STEP_KEY].has_key?('assertions')
        return
      end

      e[STEP_KEY]['assertions'].each do |a|
        puts __FILE__ + (__LINE__).to_s + " Assert => #{a.to_s}"
      end


    end


    def self.processExpected(my_driver, e)
      puts __FILE__ + (__LINE__).to_s + "\to Expected:  #{e[STEP_KEY]['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      if e[STEP_KEY].has_key?('expected')
        expected_list=e[STEP_KEY]['expected']


        if expected_list.is_a?(Array)
          expected_list.each do |_condition|
            verifyCondition(my_driver, _condition)
          end
        end

        if expected_list.is_a?(Hash)

          expected_list.each_pair do |link_name, xpath|

            puts __FILE__ + (__LINE__).to_s +  "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

            if !xpath.match(/\$\{.*\}/).nil?
              xpath = Scoutui::Base::UserVars.instance.get(xpath)
            end


            if !xpath.match(/^page\([\w\d]+\)/).nil?

              page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)

              puts __FILE__ + (__LINE__).to_s + " Process page request #{page_elt} => #{page_elt.class.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?

              if page_elt.is_a?(Hash) && page_elt.has_key?('locator')

                ##
                # expected:
                #   wait: page(abc).get(def)    where this page_elt has "locator"

                xpath = page_elt['locator'].to_s

              elsif xpath.is_a?(Hash)
                xpath.each_pair do |_k, _v|

                  puts __FILE__ + (__LINE__).to_s + " k,v :: #{_k.to_s}, #{_v.to_s}"

                  if _v.has_key?('locator')
                    _locator = _v['locator'].to_s
                    puts __FILE__ + (__LINE__).to_s + " " + _k.to_s + " => " + _locator

                  #  _locator = Scoutui::Utils::TestUtils.instance.getPageElement(_v['locator'])

                    _obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, _locator)

                    puts __FILE__ + (__LINE__).to_s + " HIT #{_locator} => #{!_obj.nil?}"
                  end

                end

                next
              end


            end

          obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, xpath)

          Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(!obj.nil?, "Verify #{xpath}")

          if obj.nil?
            puts " NOT FOUND : #{link_name} with xpath #{xpath}"
          else
            puts " link object(#{link_name} with xpath #{xpath}=> #{obj.displayed?}"  if Scoutui::Utils::TestUtils.instance.isDebug?
          end

        end
        end
      end

    end

    # Scoutui::Base::VisualTestFramework.processFile(@drv, @eyes, @test_settings['host'], @test_settings['dut'])
    def self.processFile(eyeScout, test_settings)

      my_driver = eyeScout.drv()

      baseUrl = Scoutui::Base::UserVars.instance.getHost()
      datafile = test_settings['dut']

      puts __FILE__ + (__LINE__).to_s + " processFile(#{eyeScout}, #{baseUrl}, #{datafile})" if Scoutui::Utils::TestUtils.instance.isDebug?

      valid_file=false
      i=0
      begin
        dut_dupes = YAML.load_stream File.read(datafile)
        valid_file=true
      rescue => ex
        puts __FILE__ + (__LINE__).to_s + " Invalid file: #{datafile} - abort processing."
        puts ex.backtrace
      end

      return if !valid_file

      dut_dupes.each do |e|
        puts '-' * 72 if Scoutui::Utils::TestUtils.instance.isDebug?
        puts "#{i.to_s}. Processing #{e.inspect}" if Scoutui::Utils::TestUtils.instance.isDebug?
        i+=1

        _action = e[STEP_KEY]["action"]
        _name   = e[STEP_KEY]["name"]
        _url    = e[STEP_KEY]["url"]
        _skip   = e[STEP_KEY]["skip"]
        _region = e[STEP_KEY]["region"]

        if Scoutui::Utils::TestUtils.instance.isDebug?
          puts __FILE__ + (__LINE__).to_s + " action: #{_action}"
          puts __FILE__ + (__LINE__).to_s + " name: #{_name}"
          puts __FILE__ + (__LINE__).to_s + " url : #{_url}"
          puts __FILE__ + (__LINE__).to_s + " skip: #{_skip}"
          puts __FILE__ + (__LINE__).to_s + " region: #{_region}"
        end

        skipIt = (!_skip.nil?) && (_skip.to_s.strip.downcase=='true')
        puts "\to skip : #{skipIt}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if skipIt
          puts __FILE__ + (__LINE__).to_s + " SKIP - #{_name}" if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end


        if !isRun(e).nil?

          tmpSettings=test_settings.dup
          tmpSettings["dut"]=e[STEP_KEY]["run"].to_s

          processFile(eyeScout, tmpSettings)
          puts __FILE__ + (__LINE__).to_s + " Completed execution of subfile"  if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end

        if !(_action.nil? || _action.empty?)
          processCommand(_action, e, my_driver)
          processExpected(my_driver, e)
          processAssertions(my_driver, e)

        #  puts __FILE__ + (__LINE__).to_s + " Pause"; gets()

          if isSnapIt(e)
            if !_region.nil?
              eyeScout.check_window(_name, _region)
            else
              eyeScout.check_window(_name)
            end

           # processExpected(my_driver, e)
          end

          next
        end


        if e[STEP_KEY].has_key?("url")
          url = e[STEP_KEY]["url"].to_s
          _relativeUrl = _url.strip.start_with?('/')


          if _relativeUrl
            puts __FILE__ + (__LINE__).to_s + " [relative url]: #{baseUrl} with #{url}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            url = baseUrl + url
          end

  #        name = e["page"]["name"].to_s

  #        Scoutui::Base::QHarMgr.instance.run('/tmp/url.har') { my_driver.navigate().to(url) }
          my_driver.navigate().to(url)
        end


        puts "\to Expected:  #{e[STEP_KEY]['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        processExpected(my_driver, e)
        processAssertions(my_driver, e)

         if !_region.nil?
          eyeScount.check_window(_name, _region)
        else
          eyeScout.check_window(_name)
        end

        puts "\to links : #{e[STEP_KEY]['links'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        if e[STEP_KEY].has_key?('links')
          links=e[STEP_KEY]['links']

          links.each_pair do |link_name, xpath|
            puts "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?


            obj = QBrowser.getObject(my_driver, xpath)
            puts __FILE__ + (__LINE__).to_s + " [click]: link object => #{obj.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?
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
