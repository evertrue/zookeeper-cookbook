exhibitor_build_path = ::File.join(Chef::Config[:file_cache_path], 'exhibitor')

directory exhibitor_build_path do
  owner node[:zookeeper][:user]
  mode "0755"
end

template ::File.join(exhibitor_build_path, 'build.gradle') do
  variables(
    :version => node[:exhibitor][:version] )
  action :create
end

include_recipe "zookeeper::gradle"

jar_file = "#{exhibitor_build_path}/build/libs/exhibitor-#{node[:exhibitor][:version]}.jar"

if !::File.exists?(jar_file)
  execute "build exhibitor" do
    user "root"
    cwd exhibitor_build_path
    command 'gradle jar'
  end
end

exhibitor_jar = node[:exhibitor][:jar_dest] 

if !::File.exists?(exhibitor_jar)
  execute "move exhibitor jar" do
    command "cp '#{jar_file}' '#{exhibitor_jar}' && chown '#{node[:zookeeper][:user]}:#{node[:zookeeper][:group]}' '#{exhibitor_jar}'"
  end
end
