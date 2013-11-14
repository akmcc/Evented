require 'socket'


class ChatServer

  def initialize
    @server = TCPServer.new(9393)
    @users = [@server]
    start_server
  end

  def start_server
    loop do
      readables, _ = IO.select(@users)
      readables.each do |socket|
        if socket == @server
          @users << (socket.accept)
          @users[-1].write("Welcome to the chatroom.")
        else
          message = socket.read_nonblock(4444)
          if message.match?(/exit/)
            socket.close
            @users.delete(socket)
          else
            @users[1..-1].each do |user|
              user.write(message)
            end
          end
        end
      end
    end 
  end
end