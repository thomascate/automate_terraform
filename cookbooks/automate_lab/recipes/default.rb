#
# Cookbook:: automate_lab
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'openssh'
include_recipe 'yum'

packages = [
  'atop',
  'emacs-nox',
  'nano',
  'pstree',
  'traceroute',
  'tree',
  'vim-enhanced'
]

package packages do
  action :install
end

execute 'update packages' do
  command 'yum update -y'
  action :run
end

user 'student' do
  action :create
  comment 'User for automate class'
  gid 'users'
  home '/home/student'
  shell '/bin/bash'
  password '$6$yYyTy84n$w2mQDnZBQEpUGJJhdqBCNKP4JHbTGJvN4i1Ze2IoG3Fnbshnx3Hwhv/TN0Civ0PDdFhkSff6xBvOsBa5yfk4/.'
  manage_home true
end

group 'student' do
  action :create
  members ['student']
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
