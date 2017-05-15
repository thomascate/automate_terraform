#!/usr/bin/env ruby

#This script updates dns in DNSimple based on input hostname/IP

require 'dnsimple'
require 'json'

input = ARGV
hostname = input[0]
ip = input[1]

creds_file = File.open(".dns_creds", "rb")
api_creds = JSON.parse(creds_file.read)
creds_file.close

client = Dnsimple::Client.new(access_token: api_creds['api_key'])

response = client.zones.records(
    api_creds['account_id'],
    api_creds['domain'],
    filter: {
      name: hostname
    })

if response.total_entries == 0 then

  puts "creating entry"
  client.zones.create_record(
    api_creds['account_id'],
    api_creds['domain'],
    name: hostname,
    ttl: "600",
    type: "A",
    content: ip
  )

elsif response.total_entries == 1 then

  puts "updating entry"
  client.zones.update_record(
    api_creds['account_id'],
    api_creds['domain'],
    response.data[0].id,
    ttl: "600",
    type: "A",
    content: ip
  )

else
  puts "we should never get more than 1 result back"

end
