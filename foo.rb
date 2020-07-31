#!/usr/bin/env ruby

require "pry-byebug"
require "json"
require "bundler/setup"
require "aws-sdk-ec2"

def nat_gateway_ids_for_vpc(client, vpc_id)
  filter = [ { name: "vpc-id", values: [vpc_id] } ]
  data = client.describe_nat_gateways(filter: filter)
  data.nat_gateways.map { |ng| ng.nat_gateway_id }.sort
end

def nat_gateway_ids_from_terraform_state(statefile)
  str = File.read("terraform.tfstate")
  data = JSON.parse(str)
  list = data["resources"]
  nat_gateway = list.filter { |m| m["name"] == "private_nat_gateway" }.first
  nat_gateway["instances"].map { |ng| ng.dig("attributes", "nat_gateway_id") }.sort
end

# binding.pry

ec2 = Aws::EC2::Client.new(region:'eu-west-2', profile: ENV["AWS_PROFILE"])
pp nat_gateway_ids_for_vpc(ec2, "vpc-0c16457fd570a1f0b")

pp nat_gateway_ids_from_terraform_state("terraform.tfstate")

