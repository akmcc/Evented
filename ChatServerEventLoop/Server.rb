class Server #this is a wrapper for my TCPServer

  include MockEventsEmitter

  def initialize(server)
    @server = server
  end

  def to_io
    @server
  end

  def handle_read
    user = @server.accept
    emit(:accept_new_user, Users.new(user))
  end
end