class Users  #clients? 

  include MockEventsEmitter

  def initialize(socket)
    @socket = socket
  end

  def to_io
    @socket
  end

  def handle_read
    emit(:message, self)
  end
end