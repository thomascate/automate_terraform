remote_file 'grab automate package' do
  action :create
  backup 5
  group 'root'
  mode '0644'
  owner 'root'
  path '/tmp/automate-0.7.239-1.el7.x86_64.rpm'
  source 'https://packages.chef.io/files/stable/automate/0.7.239/el/7/automate-0.7.239-1.el7.x86_64.rpm'
end

cookbook_file '/root/automate.license' do
  action :create
  group  'student'
  owner  'student'
  source 'automate.license'
end
