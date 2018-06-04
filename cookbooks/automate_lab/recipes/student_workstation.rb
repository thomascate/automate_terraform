#
# Semi-disable SELinux, because that's what you do
#
selinux_state "disable SELinux" do
  action :disabled
end

#
# Write out EC2 hints file for maximum Ohai delight
#
directory "/etc/chef/ohai/hints" do
  recursive true
  action :create
end

file "/etc/chef/ohai/hints/ec2.json" do
  content "{}"
  action :create
end

#
# Create the "dockeroot" group and put the "chef" user in it.
# This will be needed later for docker socket permissions.
#
group "dockerroot" do
  members "chef"
  action :create
end

#
# Replace chef's .bash_profile with one that contains the ChefDK
# shell-init goodness.
#
template "/home/chef/.bash_profile" do
  source "chef-bash-profile.erb"
  owner "chef"
  group "chef"
  mode "0644"
  action :create
end

# Enable the Docker Community Edition repository which is where we'll
# pull Docker from.
#
#yum_repository "docker-ce-stable" do
#  baseurl 'https://download.docker.com/linux/centos/7/$basearch/stable'
#  enabled true
#  gpgcheck true
#  gpgkey "https://download.docker.com/linux/centos/gpg"
#  action :create
#end

##
## Upgrade any old "docker" packages to the one from the docker repo
##
#package "docker" do
#  action :upgrade
#end

#
# Write out a docker sysconfig that disables SELinux support
#
template "/etc/sysconfig/docker" do
  source "docker-sysconfig.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

#
# Start the docker service
#
service "docker" do
  action [ :enable, :start ]
end

#
# Ensure the docker socket is grouped into the previously-created
# dockerroot group
#
execute "chown root:dockerroot /var/run/docker.sock" do
  action :run
end

#
# Install kitchen-docker, as the "chef" user so it gets
# installed into /home/chef/.chefdk
#
execute "sudo -u chef chef gem install kitchen-docker" do
  action :run
end

# Create our sample InSpec profile used in the workshop
#
directory "/home/chef/profiles/ssh/controls" do
  user "chef"
  group "chef"
  recursive true
  action :create
end

template "/home/chef/profiles/ssh/inspec.yml" do
  source "inspec.yml.erb"
  user "chef"
  group "chef"
  action :create
end

template "/home/chef/profiles/ssh/controls/ssh.rb" do
  source "ssh_control.erb"
  user "chef"
  group "chef"
  action :create
end

execute "chown -R chef:chef /home/chef/profiles" do
  action :run
end

#
# Create our JSON configuration used when we run Chef Solo
#
template "/home/chef/config.json" do
  source "config.json.erb"
  user "chef"
  group "chef"
  action :create
end

#
# Create the .chef directory. Terraform will create a unique
# config.rb file in this directory for each workstation.
#
directory '/home/chef/.chef' do
  user "chef"
  group "chef"
  action :create
end

#
# Install the latest audit cookbook and any of its dependencies
# using Berkshelf

directory "/home/chef/cookbooks" do
  user "chef"
  group "chef"
  action :create
end

template "/home/chef/Berksfile" do
  source "Berksfile.erb"
  user "chef"
  group "chef"
  action :create
end

execute "berks vendor cookbooks" do
  user "chef"
  group "chef"
  environment({"BERKSHELF_PATH" => "/home/chef/.berkshelf"})
  cwd "/home/chef"
end

execute "chown -R chef:chef /home/chef/cookbooks"

#
# Add our little run_chef helper script which is super-handy for workshop
# participants to kick off a chef-solo run.
#
template "/usr/bin/run_chef" do
  source "run_chef.erb"
  user "root"
  group "root"
  mode "0777"
  action :create
end

#
# Write out some workshop solutions in a "hidden" directory in case
# some participants have trouble typing out the recipe/template/kitchen
# files correctly, or if you're simply running behind on time.
#
directory "/home/chef/.solutions" do
  owner "chef"
  group "chef"
  action :create
end

template "/home/chef/.solutions/ssh.rb" do
  source "ssh.rb.erb"
  owner "chef"
  group "chef"
  mode "0644"
  action :create
end

template "/home/chef/.solutions/.kitchen.yml" do
  source "kitchen-yml.erb"
  owner "chef"
  group "chef"
  mode "0644"
  action :create
end

template "/home/chef/.solutions/sshd_config.erb" do
  source "sshd_config_fixed.erb"
  owner "chef"
  group "chef"
  mode "0644"
  action :create
end

