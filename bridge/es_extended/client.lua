if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    InitializeResource()
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    RemoveTarget()
end)

if Config.DevDebug then
    AddEventHandler('onResourceStart', function(resourceName)
        if resourceName == GetCurrentResourceName() then
            InitializeResource()
        end
    end)

    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName == GetCurrentResourceName() then
            RemoveTarget()
        end
    end)
end