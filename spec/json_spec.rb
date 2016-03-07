require 'rspec'
require 'json'
require_relative '../lib/scoutui'

describe 'Manage JSON page objects' do

  let(:static_file1) { "#{File.dirname(__FILE__)}/fixtures/static_login_page.json" }
  let(:static_file2) { "#{File.dirname(__FILE__)}/fixtures/static_home_page.json" }

  let(:qAcc) { Scoutui::Base::QAccounts.new(static_file)  }


  before do
    puts '-- before --'


  end

  after do
    puts '-- After --'
  end

  # it 'qAccounts object is not nil' do
  #   t=Scoutui::Base::QAccounts.new()
  #   expect(t).not_to be nil
  # end
  it 'convert file into JSON' do
    json = JSON.parse File.read(static_file1)
    puts "class => " + json.class.to_s
    puts "json1 => " + json.to_json
  end

  it 'should create AppModel' do
    _model = Scoutui::ApplicationModel::QModel.new(static_file1)
    expect(_model).to be_a_kind_of(Scoutui::ApplicationModel::QModel)
  end

  it 'should receive nil for unsupported getter' do
    _model = Scoutui::ApplicationModel::QModel.new(static_file1)
    _pg = _model.getPageElement('page(login)')
    puts __FILE__ + (__LINE__).to_s + " pg => #{_pg.class.to_s}"
    expect(_pg).to be_a_kind_of(Hash)
  end

  it 'get requirements' do
    app_model = JSON.parse File.read(static_file1)
    _length =  app_model['login']['login_form']['test_button']['requirements'].length
    expect(_length).to eq(2)
  end

  it 'combine two page object files in JSON format' do

    json_list = [static_file1, static_file2]
    jsonData={}
    json_list.each  { |f|
      data_hash = JSON.parse File.read(f)
      jsonData.merge!(data_hash)
    }
    puts "merged jsonData => " + jsonData.to_json

    puts "LOGIN => " + jsonData['login'].to_s


    expect(static_file1).not_to be nil
  end

end
