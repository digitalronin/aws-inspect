#!/usr/bin/env ruby

require "pry-byebug"
require "bundler/setup"
require "aws-sdk-ec2"

def nat_gateway_ids_for_vpc(client, vpc_id)
  filter = [ { name: "vpc-id", values: [vpc_id] } ]
  data = client.describe_nat_gateways(filter: filter)
  data.nat_gateways.map { |ng| ng.nat_gateway_id }
end

ec2 = Aws::EC2::Client.new(region:'eu-west-2', profile: ENV["AWS_PROFILE"])

# binding.pry

pp nat_gateway_ids_for_vpc(ec2, "vpc-0c16457fd570a1f0b")
