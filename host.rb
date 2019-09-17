require 'uri'
require 'resolv'

class Host

  def initialize(input)

    @public_ip = begin

      # they passed in an ip
      if input =~ Resolv::IPv4::Regex
        input
      else

        begin

          input = URI.parse(input).host if input.start_with? 'http'
          IPSocket.getaddress(input)
        rescue SocketError

          false # Can return anything you want here
        end
      end

    end

    @input = input
  end

  attr_accessor :input
  attr_accessor :public_ip
end