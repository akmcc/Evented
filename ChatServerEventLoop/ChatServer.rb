require 'socket'
require_relative './MockEventsEmitter'
require_relative './EventLoop'

class ChatServer

  include MockEventsEmitter

  def initialize
    @clients = []
  end
  
  def set_listeners(server)
    server.on(:accept) do |client|
        @clients << client 
        welcome(client)
        listen_to(client)
    end
  end
  
  def listen_to(client)
    client.on(:message) do |message, sender|
      forward_message(message, sender)
    end

    client.on(:close) do |client|
        sign_out(client)
    end
  end

  def forward_message(message, sender)
    recipients = @clients.select{ |client| client != sender }
    recipients.each { |recipient| recipient.to_io.write_nonblock("=> #{message}") }
  end

  def sign_out(client)
    @clients.delete(client)
  end

  def welcome(client)
    client.to_io.write_nonblock("Welcome to the Chatroom.\nType 'exit!' to leave.\n")
  end

end

