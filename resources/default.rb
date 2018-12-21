# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

property :version, String, default: 'patched'
property :source, String, default: lazy { |r| "http://www.freetds.org/files/stable/freetds-#{r.version}.tar.gz" }
property :prefix, String, default: '/usr/local'
property :target_dir, String, default: lazy { |r| ::File.join(r.prefix,'src','freetds') }
property :configure_flags, Array, default: %w(--with-tdsver=7.3)

# directory new_resource.target_dir

action :install do
  tar_package new_resource.source do
    prefix new_resource.prefix
    configure_flags new_resource.configure_flags
    creates ::File.join(new_resource.prefix,'bin','tsql')
  end
end

action :extract do
  tar_extract 'freetds' do
    source new_resource.source
    target_dir new_resource.target_dir
    creates ::File.join(new_resource.target_dir,'freetds.conf')
    tar_flags ["--strip-components=1"]
  end
end

