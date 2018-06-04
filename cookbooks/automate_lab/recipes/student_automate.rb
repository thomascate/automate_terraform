directory '/root/extras' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file 'grab automate package' do
  action :create
  backup 5
  group 'root'
  mode '0644'
  owner 'root'
  path '/root/extras/chef-automate_linux_amd64.zip'
  source 'https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip'
end

cookbook_file '/root/extras/automate.license' do
  action :create
  group  'student'
  owner  'student'
  source 'automate.license'
end

template '/home/chef/patch.toml' do
  source 'patch.toml'
  owner 'chef'
  group 'chef'
  mode '0644'
end
