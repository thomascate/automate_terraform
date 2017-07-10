chef_ingredient "chef-server" do
  config <<-EOS
api_fqdn "#{node["fqdn"]}"
EOS
  action :install
  package_source 'https://packages.chef.io/files/stable/chef-server/12.15.6/el/7/chef-server-core-12.15.6-1.el7.x86_64.rpm'
  product_name "chef-server"
end

chef_ingredient "reconfigure" do
  action :reconfigure
  product_name "chef-server"
end

remote_file "/tmp/opscode-push-jobs-server-2.2.1-1.el7.x86_64.rpm" do
  group  'student'
  owner  'student'
  source 'https://packages.chef.io/files/stable/opscode-push-jobs-server/2.2.1/el/7/opscode-push-jobs-server-2.2.1-1.el7.x86_64.rpm'
end
