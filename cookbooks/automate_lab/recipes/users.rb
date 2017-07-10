user 'student' do
  action :create
  comment 'Student user for Chef Automate Up and Running Training'
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

user 'instructor' do
  action :create
  comment 'Instructor user for Chef Automate Up and Running Training'
  home '/home/instructor'
  shell '/bin/bash'
  manage_home true
end

directory '/home/instructor/.ssh' do
  owner 'instructor'
  group 'instructor'
  mode '0700'
  action :create
end

cookbook_file '/home/instructor/.ssh/authorized_keys' do
  source 'instructor.pub'
  owner 'instructor'
  group 'instructor'
  mode '0644'
end
