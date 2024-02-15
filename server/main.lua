local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('cbd-meters:server:RobMeter', function()
	if Config.Framework == 'qb' then
		local amount = Config.Money
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)
		Player.Functions.AddMoney('cash', amount)
		QBCore.Functions.Notify('You have stolen $' .. amount .. ' from the parking meter', 'success')
	elseif Config.Framework == 'ox' then
		local amount = Config.Money
		exports.ox_inventory:AddItem(PlayerPedId(), 'money', amount)
	end
end)
