require 'socket'
require_relative './MockEventsEmitter'
require_relative './Server'
require_relative './Users'

class ChatServer

  include MockEventsEmitter

  def initialize
    @server = Server.new(TCPServer.new(9393))
    set_up(@server)
    @users = [@server]
    start_server
  end

  def set_up(server)
    server.on(:accept_new_user) do |client|
      @users << client
       client.to_io.write_nonblock("Welcome to the Chatroom.\nType 'exit' to leave.\n")
    end
  end

  def start_server
    loop do
      readables, _ = IO.select(@users)
      readables.each do |socket|
        socket.handle_read
      end
    end 
  end
end

ChatServer.new