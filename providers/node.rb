def get_zk()
  require 'zookeeper'
  # todo: memoize
  return Zookeeper.new(@new_resource.connect_str)
end

action :create_if_missing do
  zk = get_zk()
  if not zk.stat(:path => @new_resource.path)[:stat].exists?
    zk.create(:path => @new_resource.path, :data => @new_resource.data)
  end
end

action :create do
  zk = get_zk()
  if zk.stat(:path => @new_resource.path)[:stat].exists
    zk.set(:path => @new_resource.path, :data => @new_resource.data)
  else
    zk.create(:path => @new_resource.path, :data => @new_resource.data)
  end
end

action :delete do
  zk = get_zk()
  zk.delete(:path => @new_resource.path)
end
