
include_recipe "zookeeper::service"

zookeeper_node "/testing" do
  connect_str "localhost:2181"
  data "some data"
end