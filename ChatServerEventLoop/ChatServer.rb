require 'pry'
require 'socket'
require_relative './MockEventsEmitter'
require_relative './Client'
require_relative './Server'
require_relative './EventLoop'

class ChatServer

  include MockEventsEmitter

  def initialize
    @clients = []
  end

  def users
    [@server] + @clients
  end
  
  def set_listeners(server)
    server.on(:accept_new_user) do |clients|
      clients.each do |client|
        @clients << client 
        welcome(client)
        register(client)
      end
    end
  end
  
  def register(client)
    client.on(:message) do |message, sender|
      forward_message(message, sender)
    end

    client.on(:sign_out) do |clients|
      clients.each do |client|
        sign_out(client)
      end
    end
  end

  def forward_message(message, sender)
    recipients = @clients.select{ |client| client != sender }
    recipients.each { |recipient| recipient.to_io.write_nonblock("=> #{message}") }
  end

  def sign_out(client)
    client.to_io.close
    @clients.delete(client)
  end

  def welcome(client)
    client.to_io.write_nonblock("Welcome to the Chatroom.\nType 'exit' to leave.\n")
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

loop = EventLoop.new

chatter = ChatServer.new

chatter.set_listeners(loop.monitor('0.0.0.0', 9393)) 

loop.start
