module MockEventsEmitter

  def on(event, &block)
    @listeners ||= {}
    listeners = @listeners[event] ||= []
    listeners << block
  end

  def emit(event, *args)
    listeners = @listeners[event]
    listeners.each do |listener|
      listener.call(args)
    end
  end
end




