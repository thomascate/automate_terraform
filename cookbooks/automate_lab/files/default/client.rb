chef_server_url "https://demo.chefserver.e9.io:443/organizations/automate"
client_fork true
ssl_verify_mode :verify_none
validation_key "/tmp/cookbooks/delivery.pem"
validation_client_name "delivery"
interval 600
