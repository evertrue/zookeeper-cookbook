actions :create, :delete, :create_if_missing
default_action :create if defined?(default_action)
 
attribute :path, :kind_of => String, :name_attribute => true
attribute :zk_connection, :kind_of => String, :required => true
attribute :data, :kind_of => String

# zookeeper "/jones" do
#   action :create_if_missing
#   zk_connection "localhost:2181"
#   data "my-id"
# end
