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
    @clients = []
    start_server
  end

  def users
    [@server] + @clients
  end
  
  def set_listeners(server)
    server.on(:accept_new_user) do |client|
      @clients << client 
      client.socket.write_nonblock("Welcome to the Chatroom.\nType 'exit' to leave.\n")
      register(client)
    end
  end
  
  def register(client)
    client.on(:message) do |current_client|
      message = current_client.socket.read_nonblock(1000)
      if message.match(/exit/)
        sign_off(current_client)
      else
        clients = @clients.select{ |client| client != current_client }
        clients.each { |client| client.socket.write_nonblock("=> #{message}") }
      end
    end
  end

  def sign_off(client)
    client.socket.close
    @clients.delete(client)
  end

  def start_server
    loop do
      readables, _ = IO.select(users)
      readables.each do |socket|
        socket.handle_read
      end
    end 
  end
end

ChatServer.new
