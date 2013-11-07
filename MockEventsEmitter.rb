#need to initialize @listeners to {} (empty hash) in whatever class includes this module

module MockEventsEmitter

  def on(event, &block)
    listeners = @listeners[event] ||= []
    listeners << block
  end

  def emit(event)
    listeners = @listeners[event]
    listeners.each do |listener|
      listener.call
    end
  end
end