# Change this to the correct URL for the Instructor Chef Server and also ensure
# that the change is reflected in the necessary hostsfiles.
chef_server_url "https://instructor.chefserver.success.chef.co:443/organizations/automate"
client_fork true
ssl_verify_mode :verify_none
validation_key "/tmp/cookbooks/delivery.pem"
validation_client_name "delivery"
interval 600
