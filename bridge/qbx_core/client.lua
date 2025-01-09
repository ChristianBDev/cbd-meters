if GetResourceState('qbx_core') ~= 'started' then return end

QBox = exports.qbx_core

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    InitializeResource()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
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