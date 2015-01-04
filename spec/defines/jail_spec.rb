require 'spec_helper'

describe 'jail::jail', :type => :define do


  let :facts do
    {
      :kernel => 'FreeBSD',
      :osfamily => 'FreeBSD',
      :operatingsystem => 'FreeBSD',
      :operatingsystemrelease => '10.1-RELEASE',
      :kernelversion => '10.1',
      :hardwaremodel => 'amd64',
      :hardwareisa => 'amd64'
    }
  end


  let :pre_condition do
    "class {'jail':}"
  end


  describe 'Create a basejail' do
    let(:title) {'test-basejail'}

    it { is_expected.to contain_service('jail-test-basejail').with({
      :ensure => 'running',
      :hasrestart => true,
      :start => '/usr/sbin/jail -f /usr/local/etc/jail.d/test-basejail.conf -c test-basejail'
    })}
    it { is_expected.to contain_jail__download('10.1-RELEASE') }
    it { is_expected.to contain_exec("Extract base.txz in test-basejail") }
    it { is_expected.to contain_exec("Extract doc.txz in test-basejail") }
  end

  describe 'Create a jail with a basejail' do
    let :pre_condition do
      "class {'jail':} jail::jail {'basejail':}"
    end

    let(:title) {'test-jail'}
    let :params do
      {
        :basejail => 'basejail'
      }
    end

    it { is_expected.to contain_service('jail-test-jail').with({
      :ensure => 'running',
      :hasrestart => true,
      :start => '/usr/sbin/jail -f /usr/local/etc/jail.d/test-jail.conf -c test-jail',
      :stop => '/usr/sbin/jail -f /usr/local/etc/jail.d/test-jail.conf -r test-jail'
    })}

    it { is_expected.to contain_file("/mnt in test-jail") }
    it { is_expected.to contain_file("/usr in test-jail") }

  end

end
