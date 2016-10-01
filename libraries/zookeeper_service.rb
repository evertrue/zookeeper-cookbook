require 'poise_service/service_mixin'

module ZookeeperCookbook
  module Resource
    class ZookeeperService < Chef::Resource
      include Poise
      provides(:zookeeper_service)
      include PoiseService::ServiceMixin

      actions(:enable, :disable)
      default_action(:enable)


      attribute(:service_style,
               default: 'sysvinit',
               callbacks: {
                 'Must be a valid service style' =>
                   -> (service_style) { %w(runit upstart sysvinit systemd exhibitor).include? service_style }
               })
      attribute(:install_dir,       default: '/opt/zookeeper')
      attribute(:username,          default: 'zookeeper')
      attribute(:service_actions,   default: [:enable, :start])
      attribute(:template_cookbook, default: 'zookeeper')
    end
  end

  module Provider
    class ZookeeperService < Chef::Provider
      include Poise
      provides(:zookeeper_service)
      include PoiseService::ServiceMixin

      def action_enable
        notifying_block do

        end
        super
      end

      def service_options(service)
        service.service_name('zookeeper')
        service.command("#{new_resource.install_dir}/bin/zkServer.sh")
        service.directory(new_resource.install_dir)
        service.user(new_resource.username)
        service.provider new_resource.service_style.to_sym
        service.options({ 'template' => "#{new_resource.template_cookbook}:zookeeper.#{new_resource.service_style}.erb" })
        service.restart_on_update(true)
      end
    end
  end
end
