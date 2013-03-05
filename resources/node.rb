actions :create, :delete, :create_if_missing
default_action :create if defined?(default_action)

attribute :path, :kind_of => String, :default => '/', :name_attribute => true
attribute :connect_str, :kind_of => String, :required => true
attribute :data, :kind_of => String

# zookeeper_node "/jones" do
#   action :create_if_missing
#   connect_str  "localhost:2181"
#   data "my-id"
# end
