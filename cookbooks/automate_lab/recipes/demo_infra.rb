node.default['chef_client']['config'] = {
  "chef_server_url"        => "https://demo.chefserver.e9.io:443/organizations/automate",
  "ssl_verify_mode"        => ":verify_none",
  "client_fork"            => true,
  "validation_key"         => "/tmp/cookbooks/delivery.pem",
  "validation_client_name" => "delivery"
}

include_recipe 'chef-client'
include_recipe 'chef-client::config'

