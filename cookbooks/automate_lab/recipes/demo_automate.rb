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

package 'automate' do
  action :install
  source '/tmp/automate-0.7.239-1.el7.x86_64.rpm'
end

execute 'setup automate' do
  command "automate-ctl setup --license /root/automate.license --key /tmp/cookbooks/delivery.pem --server-url https://demo.chefserver.e9.io/organizations/automate --fqdn #{node['fqdn']} --enterprise AutomateClass --configure --no-build-node"
  creates '/etc/delivery/delivery.rb'
  action :run
end

append_if_no_line "configure data collection" do
  path "/etc/delivery/delivery.rb"
  line "data_collector['token'] = 'mytokenfordatacollection'"
  notifies :run, 'execute[reconfigure automate]', :immediately
end

execute 'reconfigure automate' do
  command 'automate-ctl reconfigure'
  action :nothing
end

execute 'set admin password' do
  command 'automate-ctl reset-password AutomateClass admin Cod3Can!'
  action :run
end

#install runners, terraform should wait to build automate until these exist

execute 'install runner 0' do
  command 'automate-ctl install-runner demo.runner0.e9.io student --password 934texas -y'
  action :run
end

execute 'install runner 1' do
  command 'automate-ctl install-runner demo.runner1.e9.io student --password 934texas -y'
  action :run
end
