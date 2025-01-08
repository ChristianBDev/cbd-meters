local hitLocations = {}

local function alertPD(target)
    local policeplayers = Framework.GetPlayersByJob("police")
	for _, src in pairs(policeplayers) do
		TriggerClientEvent('cbd-meters:client:addPoliceAlert', src, "Parking Meter Robbery", GetEntityCoords(GetPlayerPed(target)))
	end
end

local function collectReward(src, hash)
    local meterModels = Config.meterModels
    local valid = false
    for _, propModel in pairs(meterModels) do
        if hash == GetHashKey(propModel) then
            valid = true
            break
        end
    end
    if not valid then return end

    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    for _, hitPositions in pairs(hitLocations) do
        if #(hitPositions - playerCoords) < 10.0 then
            return TriggerClientEvent('cbd-meters:client:sendNotification', src, "Already Hit", "error", 5000)
        end
    end
    Framework.AddAccountBalance(src, "cash", Config.Money)
    TriggerClientEvent('cbd-meters:client:sendNotification', src, "Successfully hit the Parking Meter", "success", 5000)
    local chance = math.random(100)
    if chance <= Config.AlertChance then
        TriggerClientEvent('cbd-meters:client:sendNotification', src, "Cops may have been called, run away", "error", 5000)
        alertPD(src)
    end
    table.insert(hitLocations, playerCoords)
    TriggerClientEvent("cbd-meters:client:updateList", -1, hitLocations)
end

RegisterNetEvent('cbd-meters:server:robmeter', function(hash)
    local src = source
    collectReward(src, hash)
end)