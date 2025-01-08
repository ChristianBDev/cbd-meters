if GetResourceState('qbx_core') ~= 'started' then return end

QBox = exports.qbx_core

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    InitializeResource()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    RemoveTarget()
end)