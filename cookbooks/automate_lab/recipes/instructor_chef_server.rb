chef_ingredient "chef-server" do
  config <<-EOS
api_fqdn "#{node["fqdn"]}"
data_collector['root_url'] = "https://instructor.automate.success.chef.co/data-collector/v0/"
data_collector['token'] = "mytokenfordatacollection"
  EOS
  action         :install
  package_source 'https://packages.chef.io/files/stable/chef-server/12.15.6/el/7/chef-server-core-12.15.6-1.el7.x86_64.rpm'
  product_name   "chef-server"
end

chef_ingredient "reconfigure" do
  action       :reconfigure
  product_name "chef-server"
end

chef_ingredient "install push jobs server" do
  action         :install
  package_source 'https://packages.chef.io/files/stable/opscode-push-jobs-server/2.2.1/el/7/opscode-push-jobs-server-2.2.1-1.el7.x86_64.rpm'
  product_name   "push-jobs-server"
end

chef_user "delivery" do
  email       "delivery@example.com"
  first_name  "delivery"
  key_path    "/root/delivery.pem"
  last_name   "user"
  password    "Cod3Can!"
  serveradmin false
end

chef_org "automate org" do
  admins        ["delivery"]
  key_path      "/root/automate-validator.pem"
  org           "automate"
  org_full_name "automate org for chef training"
  users         ["delivery"]
end

execute "add delivery user key" do
  command "chef-server-ctl add-user-key delivery --public-key-path /tmp/cookbooks/delivery.pem.pub"
end
