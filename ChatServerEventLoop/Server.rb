class Server #this is a wrapper for my TCPServer

  include MockEventsEmitter
  
  def initialize(socket)
    @socket = socket
  end

  def handle_read
    user = @socket.accept
    emit(:accept_new_user, User.new(user))
  end

  def to_io
    @socket
  end
end
