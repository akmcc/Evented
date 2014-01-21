require_relative './Client'

class Server #this is a wrapper for my TCPServer

  include MockEventsEmitter

  def initialize(socket)
    @socket = socket
  end

  def handle_read
    user = Client.new(@socket.accept)
    emit(:accept, user)
    
  end

  #IO.select requires the objects to have a to_io method
  def to_io
    @socket
  end
end
