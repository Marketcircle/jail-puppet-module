Puppet::Type.newtype(:jail_startup) do
  desc 'Native type to add/remove jails to the jail_list'

  ensurable do
    defaultto(:present)
    newvalue(:present) do
      provider.create
    end
    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:name, :namevar => true) do
    desc 'Name of of the jail'
    newvalues(/^\S+$/)
  end
end
