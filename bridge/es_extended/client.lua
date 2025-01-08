if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    InitializeResource()
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    RemoveTarget()
end)