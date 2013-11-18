require 'pry'
require 'socket'
require_relative './MockEventsEmitter'
require_relative './Users'
require_relative './Server'


class ChatServer

  include MockEventsEmitter

  def initialize
    @server = Server.new(TCPServer.new(9393))
    set_listeners(@server)
    @users = [@server]
    start_server
  end

  
  def set_listeners(server)
    server.on(:accept_new_user) do |client|
      @users << client 
      client.to_io.write_nonblock("Welcome to the Chatroom.\nType 'exit' to leave.\n")
      register(client)
    end
  end
  
  def register(client)
    client.on(:message) do |user|
      message = user.to_io.read_nonblock(1000)
      if message.match(/exit/)
        user.close
        @users.delete(user)
      else
        @users[1..-1].each do |user|
          user.to_io.write_nonblock(message)
        end
      end
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