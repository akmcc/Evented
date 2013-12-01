require './MockEventsEmitter'
require_relative './EventLoop'

class Server #this is a wrapper for my TCPServer

  include MockEventsEmitter

  def initialize(socket)
    @socket = socket
  end

  def handle_read
    user = Client.new(@socket.accept)
    emit(:accept, user)
    
  end

  def to_io
    @socket
  end
end
