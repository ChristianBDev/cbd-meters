local robbedMeters = {}
local onCooldown = false

local function startCooldown()
    onCooldown = true
    SetTimeout(Config.Cooldown * 1000, function()
 		onCooldown = false
    end)
end

local function notifyPlayer(message, _type, time)
    local notifyType = Config.NotifyType
    if notifyType == 'qb' then
        return TriggerEvent('QBCore:Notify', message, _type, time)
    elseif notifyType == 'mythic_notify' then
        return exports['mythic_notify']:SendAlert('inform', message, time)
    elseif notifyType == 'pNotify' then
        return exports['pNotify']:SendNotification({ text = message, type = _type, timeout = time, layout = 'centerRight' })
    elseif notifyType == 'esx' then
        return ESX.ShowNotification(message, _type, time)
    elseif notifyType == 'ox' then
        return exports.ox_lib:notify({ description = message, type = _type, position = 'top' })
    elseif notifyType == 't-notify' then
        return exports['t-notify']:Alert({ style = 'info', message = message, duration = time, })
    elseif notifyType == 'wasabi_notify' then
        return exports.wasabi_notify:notify(_type, message, time, _type)
    elseif notifyType == 'custom' then
        return print("You have not set up a custom notify")
    else
        return print("You have not configured a notify")
    end
end

local function verifyMeterStatus(entity)
    local entityCoords = GetEntityCoords(entity)
    for _, hitCoords in pairs(robbedMeters) do
        if #(entityCoords - hitCoords) < 10.0 then
            return false
        end
    end
    return true
end

local function progress(entity)
    local ped = PlayerPedId()
    if Config.Progress == 'qb' then
        exports['progressbar']:Progress({
            name = "Robbing Meter",
            duration = Config.LootTime * 1000,
            label = "Robbing Meter",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = false,
            },
            animation = {
                animDict = 'anim@gangops@facility@servers@',
                anim = 'hotwire',
                flags = 16,
            },
            prop = {},
            propTwo = {}
            }, function(cancelled)
                if not cancelled then
                    startCooldown()
                    local hash = GetEntityModel(entity)
                    TriggerServerEvent('cbd-meters:server:robmeter', hash)
                    ClearPedTasks(ped)
                else
                    ClearPedTasks(ped)
                end
        end)
    elseif Config.Progress == 'ox' then
        if lib.progressBar({
            duration = Config.LootTime * 1000,
            label = 'Robbing Meter',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = false,
            },
            anim = {
                dict = 'anim@gangops@facility@servers@',
                clip = 'hotwire',
                flag = 16,
                blendIn = 8.0,
                blendOut = 8.0,
            },
        }) then
            startCooldown()
            local hash = GetEntityModel(entity)
            TriggerServerEvent('cbd-meters:server:robmeter', hash)
            ClearPedTasks(ped)
        else
            ClearPedTasks(ped)
        end
    end
end

local function robMeter(entity)
    local entCoords = GetEntityCoords(entity)
    local ped = PlayerPedId()
    TaskTurnPedToFaceCoord(ped, entCoords.x, entCoords.y, entCoords.z, 1000)
    local success = false
    if Config.SkillCheck == 'qb' then
        success = exports['qb-minigames']:Skillbar('easy', '1234')
    elseif Config.SkillCheck == 'ox' then
        success = lib.skillCheck({ 'easy', 'easy', 'easy', 'easy' }, { '1', '2', '3', '4' })
    elseif Config.SkillCheck == 'custom' then
        -- do custom skillcheck (you need to make this yourself)
    end
    if not success then
        StopAnimTask(ped, dict, animName, 300)
        notifyPlayer('You Failed The MiniGame', 'error', 5000)
        return
    end
    progress(entity)
end

local function target()
    if Config.Target == 'qb' then
        exports['qb-target']:AddTargetModel(Config.meterModels, {
            options = {
                {
                    canInteract = function(entity)
                        if onCooldown then return false end
                        if not DoesEntityExist(entity) then return end
                        return verifyMeterStatus(entity)
                    end,
                    action = function(entity)
                        robMeter(entity)
                    end,
                    item = 'screwdriverset',
                    icon = 'fas fa-coins',
                    label = "Take some money?",
                },
            },
            distance = 2,
        })
    elseif Config.Target == 'ox' then
        exports.ox_target:addModel(Config.meterModels, {
            canInteract = function(entity)
                if onCooldown then return false end
                if not DoesEntityExist(entity) then return false end
                return verifyMeterStatus(entity)
            end,
            onSelect = function(entity)
                robMeter(entity.entity)
            end,
            icon = 'fa-solid fa-coins',
            items = 'screwdriverset',
            label = 'Robbing Meter',
            distance = 2,
        })
    end
end

function RemoveTarget()
    if Config.Target == 'qb' then
        exports['qb-target']:RemoveTargetModel(Config.meterModels)
    elseif Config.Target == 'ox' then
        exports.ox_target:removeModel(Config.meterModels)
    end
end

function InitializeResource()
    target()
end

function CleanUpResource()
    RemoveTarget()
end

RegisterNetEvent('cbd-meters:client:addPoliceAlert', function(message, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 8)
    SetBlipColour(blip, 3)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    AddTextEntry(message, message)
    BeginTextCommandSetBlipName(message)
    EndTextCommandSetBlipName(blip)
    Wait(50000)
    RemoveBlip(blip)
end)

RegisterNetEvent('cbd-meters:client:sendNotification', function(message, _type, time)
    notifyPlayer(message, _type, time)
end)

RegisterNetEvent('cbd-meters:client:updateList', function(list)
    robbedMeters = list
end)