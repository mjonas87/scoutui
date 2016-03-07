
require 'singleton'


module Scoutui::Base


  class Assertions
    include Singleton

    attr_accessor :drv


    def setDriver(_drv)
      @drv=_drv
    end

    # { "visible_when" => "always" }
    def visible_when_always(_k, _v, _obj=nil)

      _locator=nil
      rc=false
      if _v.has_key?('locator')
        _locator = _v['locator'].to_s
      end

      if !_locator.nil? &&  _v.has_key?('visible_when') && _v['visible_when'].match(/always/i)
          Scoutui::Logger::LogMgr.instance.info "Verify #{_k} - #{_locator} always visible - #{!_obj.nil?.to_s}"
          Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(!_obj.nil?, "Verify #{_k} - #{_locator} always visible")
          rc=true
      end
      rc
    end

    # { "visible_when" => true }
    def visible_when_skip(_k, _v)

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " visible_when_visible : #{_v.to_s}" if Scoutui::Utils::TestUtils.instance.isDebug?
      rc=false

      if _v.is_a?(Hash) && _v.has_key?('visible_when') && _v['visible_when'].match(/skip/i)
        rc=true

        Scoutui::Logger::LogMgr.instance.asserts.info "Skip verify #{_k.to_s} - skipped"
        Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(nil, "Skip verify #{_k.to_s}")
      end

      rc
    end

    # _a : Hash
    # o locator => String
    # o visible_when => Hash
    def visible_when_visible(_a)

    end

  end



end