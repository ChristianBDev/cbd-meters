if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

Framework = {}

Framework.GetPlayersByJob = function(job)
    local players = GetPlayers()
    local playerList = {}
    for _, src in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getJob().name == job then
            table.insert(playerList, src)
        end
    end
    return playerList
end

Framework.AddAccountBalance = function(src, _type, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    if _type == 'cash' then _type = 'money' end
    return xPlayer.addAccountMoney(_type, amount)
end