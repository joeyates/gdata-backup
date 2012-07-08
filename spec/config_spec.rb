# encoding: utf-8
$: << '../lib'

require 'gdata/config'

describe Gdata::Config do

  it 'has a highline' do
    Gdata::Config.highline.should_not be_nil
  end

end

