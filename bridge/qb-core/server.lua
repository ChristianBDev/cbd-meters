if GetResourceState('qb-core') ~= 'started' then return end
if GetResourceState('qbx_core') == 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

Framework = {}

Framework.GetPlayersByJob = function(job)
    local players = QBCore.Functions.GetPlayers()
    local playerList = {}
    for _, src in pairs(players) do
        local player = QBCore.Functions.GetPlayer(src).PlayerData
        if player.job.name == job then
            table.insert(playerList, src)
        end
    end
    return playerList
end

Framework.AddAccountBalance = function(src, _type, amount)
    local player = QBCore.Functions.GetPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.Functions.AddMoney(_type, amount)
end