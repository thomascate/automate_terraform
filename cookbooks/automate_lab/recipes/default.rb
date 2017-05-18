#
# Cookbook:: automate_lab
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node.default['openssh']['server']['authorized_keys_file'] = '%h/.ssh/authorized_keys'
node.default['openssh']['server']['pubkey_authentication'] = 'yes'

include_recipe 'openssh'
include_recipe 'yum'
include_recipe 'automate_lab::users'

packages = [
  'atop',
  'curl',
  'emacs-nox',
  'nano',
  'openssl',
  'psmisc',
  'telnet',
  'traceroute',
  'tree',
  'vim-enhanced',
  'wget'
]

package packages do
  action :install
end

execute 'update packages' do
  command 'yum update -y'
  action :run
end

#crond shouldn't be relying on the old hostname, but we'll bounce it to be sure
service 'crond' do
  action :nothing
end

cookbook_file '/etc/sudoers.d/99-student' do
  source 'student_sudo'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/hosts' do
  source 'hosts.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables({
    hostname: node['fqdn']
  })
  notifies :restart, 'service[crond]'
end

#make sure bashrc shows full hostname for PS1
cookbook_file '/etc/bashrc' do
  action :create
  source 'bashrc'
  owner 'root'
  group 'root'
  mode '0644'
end
