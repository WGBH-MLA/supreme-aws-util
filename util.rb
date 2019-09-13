require 'aws-sdk'
require_relative 'ec2guy'
require_relative 'eipguy'
require_relative 'host'

# require 'pry'

require 'optparse'

Options = Struct.new(:action, :hosts, :public_ip, :instance_id)

class Parser
  def self.parse(options)
    args = Options.new()

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: ruby util.rb [options]"

      opts.on("--action=NAME", "Action To Take (swap, assign_ip)") do |n|
        args.action = n
      end

      opts.on("--hosts=HOST1,HOST2...", "Hostnames") do |h|
        args.hosts = h.split(',')
      end

      opts.on("--public-ip", "Elastic IP Address") do |i|
        args.public_ip = i
      end

      opts.on("--instance-id", "EC2 Instance ID") do |id|
        args.instance_id = id
      end

      opts.on("--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

options = Parser.parse ARGV

def swap(host_one, host_two)
  host_one_ip = EIPGuy.new(host_one.public_ip)
  host_two_ip = EIPGuy.new(host_two.public_ip)

  host_one_ec2 = EC2Guy.new(host_one_ip.associated_instance_id)
  host_two_ec2 = EC2Guy.new(host_two_ip.associated_instance_id)

  host_one_ec2.assign_ip(host_two_ip)
  host_two_ec2.assign_ip(host_one_ip)
end

def assign_ip(public_ip, instance_id)
  instance = EC2Guy.new(instance_id)
  ip = EIPGuy.new(public_ip)
  raise 'Bad Args!' unless instance && ip
  instance.assign_ip(ip)
end

action = options[:action]
raise 'Action not included!' unless action

case action
  when 'swap'
    host1 = Host.new(options[:hosts][0])
    host2 = Host.new(options[:hosts][1])
    raise "Host #{host1.name} could not be reached!" unless host1.public_ip
    raise "Host #{host2.name} could not be reached!" unless host2.public_ip
    swap(host1, host2)
  when 'assign_ip'
    raise 'Missing public ip!' unless options[:public_ip].present?
    raise 'Missing instance id!' unless options[:instance_id].present?
    assign_ip(options[:public_ip], options[:instance_id])
  else
    raise 'No valid type arg!'
end
  

puts "Wow! I'm done"