require 'uri'

class Host

  def initialize(name)

    @public_ip = begin
      name = URI.parse(name).host if name.start_with? 'http'
      IPSocket.getaddress(name)
    rescue SocketError
      false # Can return anything you want here
    end

    @name = name
  end

  attr_accessor :name
  attr_accessor :public_ip
end