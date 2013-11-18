class Users  #clients? 

  include MockEventsEmitter

  attr_accessor :socket 
  
  def initialize(socket)
    @socket = socket
  end

  def handle_read
    emit(:message, self)
  end

  def to_io
    @socket
  end
end
