require 'spec_helper'
describe 'jail' do

  context 'with defaults for all parameters' do
    it { should contain_class('jail') }
    it { should contain_file('/usr/local/puppet-jail-scripts/') }
  end
end
