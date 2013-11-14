#threaded chat server in 20 lines of code!

require 'socket'

server = TCPServer.new('10.0.1.39',9393)
@users = []

Thread.new do
	Socket.accept_loop(server) do |client|
	@users << client
	client.write("Welcome to the chatroom!")
end
end

loop do 
	if @users.size > 0
		readables, _ = IO.select(@users, nil, nil)
		readables.each do |readable|
			msg = readable.readpartial(454533)		
			@users.each do |user|
				user.write(msg)
			end
		end
	end
end


