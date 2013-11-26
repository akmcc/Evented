
require 'socket'
require_relative './Server'
require_relative './Client'
require_relative './MockEventsEmitter'


class EventLoop

  include MockEventsEmitter

  def initialize
    @stream = [] 
  end  

  def monitor(host, port)
    socket = TCPServer.new(host, port)
    server = Server.new(socket)
    register(server)
    server
  end

  def register(stream_object)
    @stream << stream_object
  end

  def start
    loop do
      readables, _ = IO.select(@stream)
      readables.each do |socket|
        socket.handle_read
      end
      #need to be collecting writables as well
    end 
  end

end