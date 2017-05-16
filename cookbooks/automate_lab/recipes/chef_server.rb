remote_file '/tmp/chef-server-core-12.15.6-1.el7.x86_64.rpm' do
  owner 'student'
  group 'student'
  mode '0644'
  source 'https://packages.chef.io/files/stable/chef-server/12.15.6/el/7/chef-server-core-12.15.6-1.el7.x86_64.rpm'
end

package 'chef-server-core' do
  action :install
  source '/tmp/chef-server-core-12.15.6-1.el7.x86_64.rpm'
end

execute 'reconfigure chef server' do
  command '/usr/bin/chef-server-ctl reconfigure'
  action :run
end
