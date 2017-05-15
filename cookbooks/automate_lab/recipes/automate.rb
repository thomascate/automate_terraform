
remote_file 'grab automate package' do
  action :create
  backup 5
  owner 'root'
  group 'root'
  mode '0644'
  path '/tmp/automate-0.7.239-1.el7.x86_64.rpm'
  source 'https://packages.chef.io/files/stable/automate/0.7.239/el/7/automate-0.7.239-1.el7.x86_64.rpm'
  checksum 'sha256checksum'
end
