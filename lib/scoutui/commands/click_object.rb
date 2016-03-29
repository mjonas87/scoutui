require_relative './commands'

module Scoutui::Commands

  class ClickObject < Command

    def _whenClicked(page_elt)

      if page_elt.is_a?(Hash) && page_elt.has_key?('when_clicked')
        Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " Verify #{page_elt['when_clicked']}"

        page_elt['when_clicked'].each do |_elt|

          _r = _elt.keys[0].to_s

          _pg = _elt[_r]

          #    _c = Scoutui::Commands::VerifyElement.new("verifyelement(" + _elt + ")")
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

    def execute(drv)
      @drv=drv if !drv.nil?

      _req = Scoutui::Utils::TestUtils.instance.getReq()
      _locator = @cmd.match(/click\s*\((.*)\)/)[1].to_s.strip
      Scoutui::Logger::LogMgr.instance.command.info __FILE__ + (__LINE__).to_s + " clickObject => #{_locator}"

      # _vars = _locator.scan(/(\$\{.*?\})/)
      # _vars.each do | _v|
      #   if _v.length==1
      #
      #     _u = Scoutui::Base::UserVars.instance.get(_v[0].to_s)
      #     puts __FILE__ + (__LINE__).to_s + " Normalize(#{_v}) => #{_u}"
      #
      #     _locator.gsub!(_v[0].to_s, _u)
      #   end
      #
      # end


      # _locator = Scoutui::Base::UserVars.instance.get(_locator)
      _locator = Scoutui::Base::UserVars.instance.normalize(_locator)

      Scoutui::Logger::LogMgr.instance.command.info __FILE__ + (__LINE__).to_s + " | translate : #{_locator}" if Scoutui::Utils::TestUtils.instance.isDebug?

      _clicked=false

      begin
        obj = Scoutui::Base::QBrowser.getObject(@drv, _locator)

        if obj
          obj.click
          _clicked=true

          page_elt = Scoutui::Utils::TestUtils.instance.getPageElement(_locator)

          Scoutui::Logger::LogMgr.instance.debug "PageElement(#{_locator}) => #{page_elt}"

          _whenClicked(page_elt)
        end

      rescue => ex
        Scoutui::Logger::LogMgr.instance.warn "Error during processing: #{$!}"
        Scoutui::Logger::LogMgr.instance.warn "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
      end

      Scoutui::Logger::LogMgr.instance.asserts.info "Verify object to click exists #{_locator} : #{obj.class.to_s} - #{!obj.nil?.to_s}"
      Scoutui::Logger::LogMgr.instance.asserts.info "Verify clicked #{_locator} - #{_clicked.to_s}"

      Testmgr::TestReport.instance.getReq(_req).testcase('click').add(!obj.nil?, "Verify object to click exists #{_locator} : #{obj.class.to_s}")
      Testmgr::TestReport.instance.getReq(_req).testcase('click').add(_clicked, "Verify clicked #{_locator}")

      setResult(_clicked)
    end

  end



end
