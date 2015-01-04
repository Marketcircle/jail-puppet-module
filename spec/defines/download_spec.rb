require 'spec_helper'
asdf
describe 'jail::download', :type => :define do
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

  describe 'With default options' do
    let(:title) { '10.1-RELEASE' }
    it { should contain_wget__fetch("download for base.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/base.txz"
    })}
    it { should contain_wget__fetch("download for doc.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/doc.txz"
    })}
    it { should contain_wget__fetch("download for games.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/games.txz"
    })}
    it { should_not contain_wget__fetch("download for kernel.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/kernel.txz"
    })}
    it { should_not contain_wget__fetch("download for lib32.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/lib32.txz"
    })}
    it { should_not contain_wget__fetch("download for ports.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/ports.txz"
    })}
    it { should_not contain_wget__fetch("download for src.txz 10.1-RELEASE (amd64)").with ({
      :source => "ftp://ftp.FreeBSD.org/pub/FreeBSD/releases/amd64/amd64/10.1-RELEASE/src.txz"
    })}
  end

  describe 'Include ports' do
    let(:title) { '10.1-RELEASE' }
    let(:params) do
      { :ports => true }
    end
    it { should contain_wget__fetch("download for base.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for doc.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for games.txz 10.1-RELEASE (amd64)")}
    it { should_not contain_wget__fetch("download for kernel.txz 10.1-RELEASE (amd64)")}
    it { should_not contain_wget__fetch("download for lib32.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for ports.txz 10.1-RELEASE (amd64)")}
    it { should_not contain_wget__fetch("download for src.txz 10.1-RELEASE (amd64)")}
  end


  describe 'All the ports' do
    let(:title) { '10.1-RELEASE' }
    let(:params) do
      { :kernel => true,
        :lib32 => true,
        :ports => true,
        :src => true
      }
    end
    it { should contain_wget__fetch("download for base.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for doc.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for games.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for kernel.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for lib32.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for ports.txz 10.1-RELEASE (amd64)")}
    it { should contain_wget__fetch("download for src.txz 10.1-RELEASE (amd64)")}
  end

end
