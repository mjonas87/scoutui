
require 'singleton'

module Scoutui::Commands


  class Utils
    include Singleton

    attr_accessor :totalCommands

    def initialize
      @command_list=['pause', 'fillform', 'submitform', 'type', 'click', 'mouseover']
      @totalCommands={}
      @command_list.each do |c|
        @totalCommands[c]=0
      end
    end

    def isClick?(_action)
      !_action.match(/click\(/).nil?
    end

    def isFillForm?(_action)
      !_action.match(/fillform\(/).nil?
    end

    def isMouseOver?(_action)
      !_action.match(/mouseover\(/).nil?
    end

    def isType?(_action)
      !_action.match(/type\(/).nil?
    end

    def isSubmitForm?(_action)
      !_action.match(/submitform\(/).nil?
    end

    def isPause?(_action)
      !_action.match(/pause/).nil?
    end

    def isValid?(cmd)

      rc=true

      if isPause?(cmd)
        @totalCommands['pause']+=1
      elsif isFillForm?(cmd)
        @totalCommands['fillform']+=1
      elsif isSubmitForm?(cmd)
        @totalCommands['submitform']+=1
      elsif isType?(cmd)
        @totalCommands['type']+=1
      elsif isClick?(cmd)
        @totalCommands['click']+=1
      elsif isMouseOver?(cmd)
        @totalCommands['mouseover']+=1
      else
        rc=false
      end

      rc
    end

  end


end
