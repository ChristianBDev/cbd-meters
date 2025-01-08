if GetResourceState('qb-core') ~= 'started' then return end
if GetResourceState('qbx_core') == 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    InitializeResource()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    RemoveTarget()
end)