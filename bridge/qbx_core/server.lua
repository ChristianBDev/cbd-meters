if GetResourceState('qbx_core') ~= 'started' then return end

QBox = exports.qbx_core

Framework = {}

Framework.AddAccountBalance = function(src, _type, amount)
    local player = QBox:GetPlayer(src)
    if _type == 'money' then _type = 'cash' end
    return player.Functions.AddMoney(_type, amount)
end

Framework.GetPlayersByJob = function(job)
    local playerList = {}
    local players = QBox:GetQBPlayers()
    for src, player in pairs(players) do
        if player.PlayerData.job.name == job then
            table.insert(playerList, src)
        end
    end
    return playerList
end