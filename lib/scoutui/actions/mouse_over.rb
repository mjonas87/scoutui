
module Scoutui::Actions
  class MouseOver < Action
    def _whenHovered(page_elt)
      if page_elt.is_a?(Hash) && page_elt.has_key?('when_hovered')
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Verify #{page_elt['when_hovered']}"

        page_elt['when_hovered'].each do |_elt|

          _r = _elt.keys[0].to_s

          _pg = _elt[_r]

          #    _c = Scoutui::Actions::VerifyElement.new("verifyelement(" + _elt + ")")
          #    _c.execute(@drv)

          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " processPageElement(#{_pg})"


          if _pg.is_a?(Array)
            _pg.each do |_pg2|
              isVisible=Scoutui::Base::Assertions.instance.isVisible(@drv, _pg2, _r)
            end
          elsif _pg.is_a?(String)
            isVisible=Scoutui::Base::Assertions.instance.isVisible(@drv, _pg, _r)
          else
            puts __FILE__ + (__LINE__).to_s + " => #{_pg}"
          end

          puts __FILE__ + (__LINE__).to_s + " IsVisible #{isVisible} - PAUSE"; gets
        end
      end
    end

    def execute(drv=nil)
      _rc=false
      _req = Scoutui::Utils::TestUtils.instance.getReq()

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " MouseOver.execute(#{@cmd})"

      @drv=drv if !drv.nil?

      begin
        _locator = @cmd.match(/mouseover\s*\((.*)\)/)[1].to_s.strip
        obj = Scoutui::Base::QBrowser.getObject(@drv, _locator)

        if !obj.nil?
          @drv.action.move_to(obj).perform
          _rc=true


          page_elt = Scoutui::Utils::TestUtils.instance.get_model_node(_locator)
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " PageElement(#{_locator}) => #{page_elt}"
          _whenHovered(page_elt)


          #------------

          appModel = Scoutui::Utils::TestUtils.instance.getAppModel()

          triggers = appModel.itemize('visible_when', 'mouseover', _locator)
          Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " triggers => #{triggers}"

          if !(triggers.nil? || triggers.empty?)

            triggers.each do |_pageObj|
              _tObj=nil

              if !_pageObj.match(/^page\([\w\d]+\)/).nil?
      #         _tObj = Scoutui::Base::VisualTestFramework.processPageElement(@drv, 'peter', _pageObj)

                _tLocator = Scoutui::Utils::TestUtils.instance.get_model_node(_pageObj)
                _tObj = Scoutui::Base::QBrowser.getFirstObject(@drv, _tLocator['locator'])

              else
                _tObj = Scoutui::Base::QBrowser.getFirstObject(@drv, _pageObj, Scoutui::Actions::Utils.instance.getTimeout())
              end

              Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " HIT #{_pageObj} => #{!_tObj.nil?}"

              Scoutui::Logger::LogMgr.instance.asserts.info "Verify #{_pageObj} is visible when mouseover #{_locator} - #{!_tObj.nil?.to_s}"
              Testmgr::TestReport.instance.getReq(_req).get_child('mouseover').add(!_tObj.nil?, "Verify #{_pageObj} is visible when mouseover #{_locator}")
            end

          end



        end

      rescue => ex
        Scoutui::Logger::LogMgr.instance.warn "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.warn "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
      end

      Testmgr::TestReport.instance.getReq(_req).testcase('mouseover').add(!obj.nil?, "Verify object #{_locator} to mouseover exists : #{obj.class.to_s}")
      Testmgr::TestReport.instance.getReq(_req).testcase('mousseover').add(_rc, "Verify mouseover #{_rc} performed for #{_locator}")
      setResult(_rc)



    end



  end


end
