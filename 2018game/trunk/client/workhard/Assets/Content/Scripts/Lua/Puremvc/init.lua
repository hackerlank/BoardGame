--require("lfs")
--package.path = package.path .. ';' .. lfs.currentdir()

pm = pm or {}
pm.VERSION = '1.0.0'
pm.FRAMEWORK_NAME = 'Puremvc Lua'
pm.PACKAGE_NAME = 'Puremvc'

--Command::register game extra command
pm.RERGISTER_EXTRA_COMMAND = 'register_extra_command'


depends(pm.PACKAGE_NAME .. '.help.oop')

pm.Facade = depends(pm.PACKAGE_NAME .. '.patterns.facade.Facade')
pm.Mediator = depends(pm.PACKAGE_NAME .. '.patterns.mediator.Mediator')
pm.Proxy = depends(pm.PACKAGE_NAME .. '.patterns.proxy.Proxy')
pm.SimpleCommand = depends(pm.PACKAGE_NAME .. '.patterns.command.SimpleCommand')
pm.MacroCommand = depends(pm.PACKAGE_NAME .. '.patterns.command.MacroCommand')
pm.Notifier = depends(pm.PACKAGE_NAME .. '.patterns.observer.Notifier')
pm.Notification = depends(pm.PACKAGE_NAME .. '.patterns.observer.Notification')

--this is used to init mvc,we will register all common command of games. such as::
--update_finished, resource_mananger_inited, update_failure etc... all of them is 
--service for game update and game login. it was invoked only at launch game....
pm.InitPuremvc = function()
	
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	if facade == nil then 
		UnityEngine.Debug.LogError("Failed to init game facade with " .. GAME_FACADE_NAME)
		return
	end 
	UnityEngine.Debug.Log("Init lua pure mvc...")
	--register all common command. all of them was saved into lua_common.u files
	local commonExtraCommand = depends('Common.Controller.RegisterUpdatesCommand')
	local executeCmd = commonExtraCommand.new()
	executeCmd:execute(nil)
end 

pm.ClearPurcemvc = function()
	local facade = pm.Facade.getInstance(GAME_FACADE_NAME)
	facade.removeCore(GAME_FACADE_NAME)
end 