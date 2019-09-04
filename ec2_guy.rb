class EC2Guy
  def initialize(instance_id)
    @instance_id = instance_id
  end

  attr_accessor :instance_id
end