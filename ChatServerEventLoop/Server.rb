class Server < Users #this is a wrapper for my TCPServer

  def handle_read
    user = @socket.accept
    emit(:accept_new_user, Users.new(user))
  end
end
