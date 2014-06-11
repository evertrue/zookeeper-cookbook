# providers/config.rb

def initialize(new_resource, run_context)
  super
  @path   = new_resource.path
  @config = new_resource.config
  @user   = new_resource.user
  @zoocfg = zookeeper_config_resource(@path)
end

action :render do
  @zoocfg.owner(@user)
  @zoocfg.group(@user)
  @zoocfg.content(render_config(@config))
  @zoocfg.run_action(:create)
end

action :delete do
  Chef::Log.info("Deleting Zookeeper config at #{@path}")
  FileUtils.rm(@path)
end

private

# Zookeeper uses a Java properties file style of configuration. This helper
# method will render a hash in that style.
def render_config(config, lead=nil)
  rendered = ""

  config.each_pair do |k,v|
    if lead
      rendered << "#{lead}."
    end

    if v.is_a?(Hash)
      rendered << render_config(v, k)
    else
      rendered << "#{k}=#{v}\n"
    end
  end

  return rendered
end

def zookeeper_config_resource(path='')
  return Chef::Resource::File.new(path, @run_context)
end
