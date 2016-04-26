

require 'spec_helper'

describe Scoutui do

  it 'Verify click command present' do
    q=Scoutui::Actions::Utils.instance.isClick?('click(abc)')
    expect(q).to be true
  end


  it 'Verify pause command present' do
    q=Scoutui::Actions::Utils.instance.isPause?('pause')
    expect(q).to be true
  end

  it 'Verify mouseover present' do
    q=Scoutui::Actions::Utils.instance.isMouseOver?('mouseover(abc)')
    expect(q).to be true
  end

  it 'Verify type present' do
    q=Scoutui::Actions::Utils.instance.isType?('type(abc, ${dut})')
    expect(q).to be true
  end

  it 'Verify fillform present' do
    q=Scoutui::Actions::Utils.instance.isFillForm?('fillform(abc, ${dut})')
    expect(q).to be true
  end

  it 'Verify submitform present' do
    q=Scoutui::Actions::Utils.instance.isSubmitForm?('submitform(abc, ${dut})')
    expect(q).to be true
  end

  it 'Verify valid command detected' do
    q=Scoutui::Actions::Utils.instance.isValid?('submitform(abc, ${dut})')
    expect(q).to be true
  end

  it 'Verify invalid command detected' do
    q=Scoutui::Actions::Utils.instance.isValid?('foo(abc, ${dut})')
    expect(q).to be false
  end


  # it 'does something useful' do
  #   expect(false).to eq(true)
  # end
end
