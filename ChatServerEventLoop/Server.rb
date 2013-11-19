class Server < User #this is a wrapper for my TCPServer

  def handle_read
    user = @socket.accept
    emit(:accept_new_user, User.new(user))
  end
end
