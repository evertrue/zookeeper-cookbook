#
# Cookbook Name:: zookeeper
# Recipe:: Exhibitor
#
# Copyright 2012, Simple
#
# All rights reserved - Do Not Redistribute
#


remote_file "/tmp/exhibitor-#{node[:exhibitor][:version]}.tar.gz" do
  source "https://github.com/Netflix/exhibitor/archive/exhibitor-#{node[:exhibitor][:version]}.tar.gz"
  mode "0644"
end

["/opt/exhibitor",
  node[:exhibitor][:snapshot_dir],
  node[:exhibitor][:transaction_dir],
  node[:exhibitor][:log_index_dir]
].each do |dir|
    directory dir do
      owner "root"
      group "root"
      mode 0755
    end
end

bash "untar exhibitor" do
  user "root"
  cwd "/tmp"
  code %(tar zxf exhibitor-#{node[:exhibitor][:version]}.tar.gz)
  not_if { File.exists? "/tmp/exhibitor-exhibitor-#{node[:exhibitor][:version]}" }
end

bash "build exhibitor" do
  user "root"
  cwd "/tmp/exhibitor-exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle"
  code %(/tmp/exhibitor-exhibitor-#{node[:exhibitor][:version]}/gradlew jar)
  not_if {File.exists? "/tmp/exhibitor-exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle/build/" }
end

bash "move exhibitor jar" do
  user "root"
  code %(cp /tmp/exhibitor-exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle/build/libs/gradle-1.4.2.jar /opt/exhibitor/exhibitor-#{node[:exhibitor][:version]}.jar)
  not_if {File.exists? "/opt/exhibitor/exhibitor-#{node[:exhibitor][:version]}.jar"}
end

service "exhibitor" do
end
# java -jar build/libs/gb-1.4.2.jar --configtype file --fsconfigdir ~/exhibitor_config
# java -jar /opt/exhibitor/exhibitor-1.4.3.jar -cs3 --s3config mwhooker-exhibitor-dev:exhibitor-config --s3backup true --s3credentials ./s3credentials
#
# TODO
# s3credentials template
# Store initial config in chef?
#   how to bootstrap new cluster
#   according to dox, just enter it through an exhibitor before going live.
# JMX? (servo) -- monitoring
# Create snapshot directory (DONE)
# Create Transaction directory (DONE)
# needs to run with permissions to edit the zookeeper conf file
#   (do we place this somewhere else? how do configure?)
