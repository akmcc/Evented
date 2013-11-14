class Users  #clients? 

  include MockEventsEmitter

  def initialize(socket)
    @socket = socket
  end

  def to_io
    @socket
  end

  def handle_read
    message = self.to_io.read_nonblock(1000)
      if message.match(/exit/)
        self.close
        @users.delete(self) #doesn't know about @users yet. Need to set up callbacks
      else
        @users[1..-1].each do |user|
          user.write_nonblock(message)
        end
      end
  end
end