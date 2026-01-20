local hitLocations = {}

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
            return Bridge.Notify.SendNotify(src, Bridge.Language.Locale("error.already_robbed"), "error", 5000)
        end
    end
    Bridge.Framework.AddAccountBalance(src, "cash", Config.Money)
    Bridge.Notify.SendNotify(src, Bridge.Language.Locale("success.robbery_complete"), "success", 5000)
    table.insert(hitLocations, playerCoords)
    TriggerClientEvent("cbd-meters:client:updateList", -1, hitLocations)
end

RegisterNetEvent('cbd-meters:server:robmeter', function(hash)
    if not source then return end
    collectReward(source, hash)
end)