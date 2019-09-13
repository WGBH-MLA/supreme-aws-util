class EIPGuy
  def initialize(public_ip)
    @client = Aws::EC2::Client.new(region: 'us-east-1')
    @public_ip = public_ip
  end

  attr_accessor :public_ip

  def address_desc
    @address_desc = begin
      @client.describe_addresses({filters: [{name: 'public-ip', values: [@public_ip]}]}).addresses.first
    end
  end

  def associated_instance_id
    address_desc.instance_id
  end

  def allocation_id
    address_desc.allocation_id
  end
end