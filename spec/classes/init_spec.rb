require 'spec_helper'
describe 'jail' do

  context 'with defaults for all parameters' do
    it { should contain_class('jail') }
  end
end
