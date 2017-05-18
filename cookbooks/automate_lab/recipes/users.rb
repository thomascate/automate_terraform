
user 'adufour' do
  action :create
  comment 'Andrew Dufour'
  home '/home/adufour'
  shell '/bin/bash'
  supports :manage_home => true
end

directory '/home/adufour/.ssh' do
  owner 'adufour'
  group 'adufour'
  mode '0700'
  action :create
end

cookbook_file '/home/adufour/.ssh/authorized_keys' do
  source 'adufour.pub'
  owner 'adufour'
  group 'adufour'
  mode '0600'
end

user 'job' do
  action :create
  comment 'Josh Obrien'
  home '/home/job'
  shell '/bin/bash'
  manage_home true
end

directory '/home/job/.ssh' do
  owner 'job'
  group 'job'
  mode '0700'
  action :create
end

cookbook_file '/home/job/.ssh/authorized_keys' do
  source 'job.pub'
  owner 'job'
  group 'job'
  mode '0600'
end

user 'student' do
  action :create
  comment 'User for automate class'
  gid 'users'
  home '/home/student'
  shell '/bin/bash'
  password '$6$Sw5.l8BU$/oHW/Ctd8i0erOlq07F9vzvnwSHQXLN8/a9U7QVFGcbRemoSTEFc9SeCG1Z6cANnuk9nh3v2K5JGG/8oKE7S81'
  manage_home true
end

group 'student' do
  action :create
  members ['student']
end

user 'tcate' do
  action :create
  comment 'Thomas Cate'
  home '/home/tcate'
  shell '/bin/bash'
  manage_home true
end

directory '/home/tcate/.ssh' do
  owner 'tcate'
  group 'tcate'
  mode '0700'
  action :create
end

cookbook_file '/home/tcate/.ssh/authorized_keys' do
  source 'tcate.pub'
  owner 'tcate'
  group 'tcate'
  mode '0644'
end
