local EndGameCommand = class('EndGameCommand', pm.SimpleCommand)

function EndGameCommand:ctor()
	self.executed = false
end

function EndGameCommand:execute(note)
	local GameMode = GetLuaGameManager().GetGameMode();
	if GameMode ~= nil then 
		GameMode:EndGame(note.body);
	end 
end
return EndGameCommand