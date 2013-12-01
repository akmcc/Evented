class Client 

  include MockEventsEmitter
  
  def initialize(socket)
    @socket = socket
  end

  def handle_read 
    message = to_io.read_nonblock(1000) 
    if message.downcase.match(/\Aexit\!/) 
      emit(:close, self)
      to_io.close
    else
      emit(:message, [message, self]) 
    end
  end

  def to_io
    @socket
  end

end
