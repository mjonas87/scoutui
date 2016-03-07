require 'rspec'


describe 'ScoutUI Logger' do


  let(:static_loc_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_localization.json" }
 # let(:logger) { Scoutui::Logger.instance }


  it 'should log to debug' do

    Scoutui::Logger::LogMgr.instance.log('debug', "This is a debug msg")

  end


  it 'should log to info' do

    Scoutui::Logger::LogMgr.instance.info("This is your information")

  end

  it 'should log to warning' do

    Scoutui::Logger::LogMgr.instance.log('warn', "This is your final warning")

  end

  it 'should log to fatal' do

    Scoutui::Logger::LogMgr.instance.fatal("Fatal warning")

  end

end