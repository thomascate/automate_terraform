user 'student' do
  action :create
  comment 'Student user for Chef Automate Up and Running Training'
  gid 'users'
  home '/home/student'
  shell '/bin/bash'
  password '$6$GSLU5IWA$21JNoNcKsj53w.F1oE7BRqIVXnJ/LT.ILwlr4pXRs169b8O.HPijZTPA4pKKoz4oDAfBfuITz5R2A9GfzjOQ21'
  manage_home true
end

user 'chef' do
  action :create
  comment 'chef user for Chef Automate Up and Running Training'
  gid 'users'
  home '/home/chef'
  shell '/bin/bash'
  password '$6$GSLU5IWA$21JNoNcKsj53w.F1oE7BRqIVXnJ/LT.ILwlr4pXRs169b8O.HPijZTPA4pKKoz4oDAfBfuITz5R2A9GfzjOQ21'
  manage_home true
end

group 'student' do
  action :create
  members ['student', 'chef']
end

group 'chef' do
  action :create
  members ['chef']
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

