local QBCore = exports['qb-core']:GetCoreObject()
OnCooldown = false

function PoliceAlert()
	if Config.Framework == 'qb' then
		TriggerServerEvent('police:server:policeAlert', 'Parking Meter Robbery')         --QB Police Alert
	elseif Config.Framework == 'ox' then
		TriggerServerEvent('police:server:CreateBlip', 14, 500, 0, 0, 'Parking Meter Robbery') --OX Police Alert
	end
end

CreateThread(function()
	Target()
end)

function StartCooldown()
	OnCooldown = true
	SetTimeout(Config.Cooldown * 1000, function()
		OnCooldown = false
	end)
end

function Target()
	if not OnCooldown then
		if Config.Framework == 'qb' then
			exports['qb-target']:AddTargetModel(Config.Meters, {
				options = {
					{
						action = function()
							RobMeter()
						end,
						icon = 'fas fa-screwdriver',
						item = 'screwdriverset',
						label = Lang:t('info.rob'),
					},
				},
				distance = 2
			})
		elseif Config.Framework == 'ox' then
			exports.ox_target:addModel(Config.Meters, {
				name = Lang:t('info.rob'),
				onSelect = function()
					RobMeter()
				end,
				icon = 'fa-solid fa-handcuffs',
				items = 'screwdriverset',
				label = 'Rob Parking Meter',
				distance = 2,
			})
		end
	else
		QBCore.Functions.Notify(Lang:t('notify.cooldown'), 'error')
	end
end

function RobMeter()
	local ped = PlayerPedId()
	local success = exports['qb-minigames']:Skillbar('medium') -- calling like this will just change difficulty and still use 1234

	if Config.Framework == 'qb' then
		if not OnCooldown and QBCore.Functions.HasItem('screwdriverset') and not IsPedInAnyVehicle(ped, true) then
			if success then
				QBCore.Functions.Progressbar('RobMeter', Lang:t('progress.grabcash'), Config.LootTime * 1000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {
					animDict = 'anim@gangops@facility@servers@',
					anim = 'hotwire',
					flags = 16,
				}, {}, {}, function() -- Done
					PoliceAlert()
					TriggerServerEvent('cbd-meters:server:RobMeter')
					StartCooldown()
				end, function() -- Cancel
					QBCore.Functions.Notify(Lang:t('notify.failed'), 'error')
				end)
			end
		elseif OnCooldown then
			QBCore.Functions.Notify(Lang:t('notify.cooldown'), 'error')
		else
			QBCore.Functions.Notify(Lang:t('notify.failed'), 'error')
		end
	elseif Config.Framework == 'ox' then
		local oxsuccess = lib.skillCheck({ 'medium', 'medium', 'medium', 'medium' }) -- uses default "E" muscle

		if not OnCooldown and exports.ox_inventory:Search('slots', 'weapon_wrench') and not IsPedInAnyVehicle(ped, true) then
			if oxsuccess then
				if lib.progressBar({
						duration = Config.LootTime * 1000,
						label = 'Grabbing Extra Change!',
						useWhileDead = false,
						canCancel = true,
						disable = {
							move = true,
							car = true,
							mouse = false,
							combat = true
						},
						anim = {
							dict = 'anim@gangops@facility@servers@',
							clip = 'hotwire'
						},
					}) then
					PoliceAlert()
					TriggerServerEvent('cbd-meters:server:RobMeter')
					StartCooldown()
				else
					exports.ox_notify:Alert('error', 'Failed to rob parking meter')
				end
			end
		end
	end
end
