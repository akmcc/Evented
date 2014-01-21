
require 'socket'
require_relative './Server'
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

    stream_object.on(:accept) do |stream|
        register(stream)
    end

    stream_object.on(:close) do |stream|
        @stream.delete(stream)
    end
  end

  def start
    loop do 
      readables, _ = IO.select(@stream)
      readables.each do |socket|
        socket.handle_read
      end
    end 
  end
end