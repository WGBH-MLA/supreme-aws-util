class EC2Guy
  def initialize(instance_id)
    @client = Aws::EC2::Client.new(region: 'us-east-1')
    @instance_id = instance_id
    @instance = Aws::EC2::Instance.new(@instance_id)
  end

  attr_accessor :client
  attr_accessor :instance_id
  attr_accessor :instance

  def current_ip_obj
    # assuming that this instance only has one public IP
    @elastic_ip = @instance.vpc_addresses.first
  end

  def current_ip
    @current_ip = current_ip_obj.data.public_ip
  end

  def current_allocation_id
    @current_allocation_id = current_ip_obj.data.allocation_id
  end

  def current_association_id
    @current_association_id = current_ip_obj.data.association_id
  end

  def assign_ip(eip_obj)
    raise "Instance #{@instance_id} is already associated with EIP #{eip_obj.public_ip}!" if current_ip == eip_obj.public_ip
    # release the hounds
    # @client.release_address({allocation_id: current_allocation_id, dry_run: false}) if current_allocation_id

    # disassociate the hounds
    @client.disassociate_address({
      dry_run: false,
      association_id: current_association_id
    })

    # associate the hounds
    @client.associate_address({
      dry_run: false,
      instance_id: @instance.id,
      allocation_id: eip_obj.allocation_id
    })
  end
end
