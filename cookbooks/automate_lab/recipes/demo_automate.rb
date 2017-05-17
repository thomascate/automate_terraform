#chef_ingredient "automate" do
#  action :install
#  chef_user 'delivery'
#  chef_user_pem '/tmp/cookbooks/delivery.pem'
#  enterprise 'automate_training_ent'
#  package_source 'https://packages.chef.io/files/stable/automate/0.7.239/el/7/automate-0.7.239-1.el7.x86_64.rpm'
#  product_name "chef-automate"
#end

chef_file  "automate.license" do
  filename "automate.license"
  group    "root"
  source   "/tmp/cookbooks/automate_lab/files/default/automate.license"
  user     "root"
end

chef_ingredient "reconfigure" do
  action :reconfigure
  product_name "automate"
end

# Everything below this was on the remote server
chef_automate "automate" do
  config <<-EOS
  delivery_fqdn "#{node['fqdn']}"
  EOS
  action :create
  chef_user 'delivery'
  chef_user_pem '/tmp/cookbooks/delivery.pem'
  enterprise 'automate_training_ent'
  license '/tmp/cookbooks/automate_lab/files/default/automate.license'
#  package_source 'https://packages.chef.io/files/stable/automate/0.7.239/el/7/automate-0.7.239-1.el7.x86_64.rpm'
#  product_name "automate"
  validation_pem File::read("/tmp/cookbooks/delivery.pem")
  builder_pem File::read("/tmp/cookbooks/delivery.pem")
end

chef_file  "automate.license" do
  filename "automate.license"
  group    "root"
  source   "/tmp/cookbooks/automate_lab/files/default/automate.license"
  user     "root"
end

chef_ingredient "reconfigure" do
  action :reconfigure
  product_name "automate"
end
