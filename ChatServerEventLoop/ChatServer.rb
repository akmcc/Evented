require 'pry'
require 'socket'
require_relative './MockEventsEmitter'
require_relative './Client'
require_relative './Server'


class ChatServer

  include MockEventsEmitter

  def initialize(host, port)
    @server = Server.new(TCPServer.new(host, port))
    set_listeners(@server)
    @clients = []
    start_server
  end

  def users
    [@server] + @clients
  end
  
  def set_listeners(server)
    server.on(:accept_new_user) do |clients|
      clients.each do |client|
        @clients << client 
        client.to_io.write_nonblock("Welcome to the Chatroom.\nType 'exit' to leave.\n")
        register(client)
      end
    end
  end
  
  def register(client)
    client.on(:message) do |message, current_client|
        recipients = @clients.select{ |client| client != current_client }
        recipients.each { |recipient| recipient.to_io.write_nonblock("=> #{message}") }
      end

    client.on(:sign_out) do |clients|
      clients.each do |client|
        sign_out(client)
      end
    end
  end

  def sign_out(client)
    client.to_io.close
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



ChatServer.new('0.0.0.0', 9393) #want this to take the host and port, code doesn't yet support it
