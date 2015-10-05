
module Scoutui::Base

  class QAccounts


    attr_accessor :dut
    attr_accessor :accounts

    def initialize(f)

      if !f.nil?
        @accounts = YAML.load_stream File.read(f)
      end

    end

    def _find(id, attr)
      hit = accounts.find { |h| h['account']['loginid'] == id }
      if !hit.nil?
        id=hit['account'][attr]
      end
      id
    end

    def getUserRecord(u)
      hit=nil

      userid=getUserId(u)
      if !userid.nil?
        hit={'userid' => getUserId(u), 'password' => getPassword(u) }
      end

      hit
    end

    def getUserId(userid)
      id=nil
      hit = accounts.find { |h| h['account']['loginid'].to_s == userid.to_s }
      if !hit.nil?
        id=hit['account']['loginid']
      end
      id
    end

    def getPassword(u)
      _find(u, 'password')
    end

  end

end
