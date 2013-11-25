class Client 

  include MockEventsEmitter
  
  def initialize(socket)
    @socket = socket
  end

  def handle_read #this should do more work than it is doing
    message = to_io.read_nonblock(1000) 
    if message.match(/exit/) #need to allow exit to be in a sentence
      emit(:sign_out, self)
    else
      emit(:message, message, self)
    end
  end

  def to_io
    @socket
  end

end
