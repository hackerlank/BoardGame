local JoinGameCommand = class('JoinGameCommand', pm.SimpleCommand)


function JoinGameCommand:ctor()
	self.executed = false
end

function JoinGameCommand:execute(note)
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	local proxy = facade:retrieveProxy(nn.GAME_PROXY_NAME)
	--order
	proxy:JoinGame(note.body)
end

return JoinGameCommand