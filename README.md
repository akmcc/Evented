Event Loop & Chat Server
=========

The ChatServerEventLoop project was created in an attempt to gain a better understanding of asynchronous and socket programming. 

The event loop is a rudimentary recreation of EventMachine's Reactor. It monitors and responds to socket events. 

The chat server runs in the event loop on the command line. Users can enter the chat space by conecting to the specified port. 

## Example Use

1. Create the loop ```loop = EventLoop.new``` 
2. Create a new instance of ChatServer ```chatter = ChatServer.new```
3. Select a port to monitor and set listeners for incoming connections ```chatter.set_listeners(loop.monitor('HOST', PORT))``` 
4. Start the loop ```loop.start```

## TODOS:

1. Blocking writes