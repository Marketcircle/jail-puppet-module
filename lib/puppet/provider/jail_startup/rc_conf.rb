require 'puppet'

Puppet::Type.type(:jail_startup).provide :rc_conf do
  confine :operatingsystem => [:freebsd]
  defaultfor :operatingsystem => [:freebsd]

  def self.rcconf
    '/etc/rc.conf'
  end

  def error(msg)
    raise Puppet::Error, msg
  end

  def self.jails
    s = File.read self.rcconf
    s.lines.each do |line|
      matches = /jail_list="(.*)"/.match line
      if matches
        jails_list = matches[0].gsub /jail_list="(.*)"/, '\1'
        return jails_list.split
      end
    end
    return nil
  end

  def jails_list
    jls = self.class.jails
    if jls
      return jls
    end
    return []
  end

  def add_rc_line line
    file = File.open self.class.rcconf, 'a'
    file << line
    file.close
  end

  def remove_rc_line name
    s = File.read self.class.rcconf
    s.gsub! /^jail_list=(.*)$\n/, ''
    f = File.open self.class.rcconf, 'w'
    f.write s
    f.close

  end

  def remove_jail name
    jails = self.jails_list
    if jails.include? name
      jails.delete name
      remove_rc_line 'jail_list'
      add_rc_line "jail_list=\"#{jails.join(' ')}\"\n"

    end

  end

  def add_jail name
    jails = self.jails_list
    if not jails.include? name
      jails.push name
      remove_rc_line 'jail_list'
      add_rc_line "jail_list=\"#{jails.join(' ')}\"\n"
    end
  end

  def self.instances
    self.jails.each do |jail|
      new(:name => jail)
    end
  end
  def create
    self.add_jail resource[:name]
  end

  def destroy
    self.remove_jail resource[:name]
  end

  def exists?
    self.jails_list.include? resource[:name]
  end
end
