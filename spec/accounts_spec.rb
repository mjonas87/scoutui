require 'rspec'

describe 'Manage Accounts' do

  let(:static_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_accounts.yaml" }
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


  it 'qAccounts object is not nil' do
    expect(qAcc).not_to be nil
  end

  it 'should be no account retrieved' do
    u = qAcc.getUserRecord('_____Non_Existent_User______')
    expect(u).to be_nil
  end

  it 'should be account retrieved' do
    u = qAcc.getUserRecord('administrator')
    expect(u).not_to be_nil
  end


  it 'should be account userId retrieved' do
    u = qAcc.getUserRecord('administrator')
    expect(u['userid']).to eq('administrator')
  end

  it 'should be account password retrieved' do
    u = qAcc.getUserRecord('administrator')
    expect(u['password']).to eq('password123')
  end

  it 'should be Hash retrieved' do
    u = qAcc.getUserRecord('administrator')
    expect(u).to be_instance_of(Hash)
  end



  describe('Verify getUserId') do

    before do
      puts '------ before -------'
    end

    after do
      puts '------ after -------'
    end

    it 'should be nil retrieved' do
      u = qAcc.getUserId('___No-Body-but-Air____')
      expect(u).to be_nil
    end


    it 'should be userId retrieved' do
      u = qAcc.getUserId('administrator')
      expect(u).to eq('administrator')
    end

  end



end