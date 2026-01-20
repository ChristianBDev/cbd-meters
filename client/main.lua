local robbedMeters = {}
local onCooldown = false

local function startCooldown()
    onCooldown = true
    SetTimeout(Config.Cooldown * 1000, function()
        onCooldown = false
    end)
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

local function robMeter(entity)
    local entCoords = GetEntityCoords(entity)
    local ped = PlayerPedId()

    TaskTurnPedToFaceCoord(ped, entCoords.x, entCoords.y, entCoords.z, 1000)

    if not BeginMiniGame(entity) then
        StopAnimTask(ped, dict, animName, 300)
        Bridge.Notify.SendNotify(Bridge.Language.Locale('error.failed_minigame'), 'error', 5000)
        ClearPedTasks(ped)
        return
    end
    local success = Bridge.ProgressBar.Open({
        duration = 5000,
        label = Bridge.Language.Locale('info.rob_meter'),
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = "anim@gangops@facility@servers@",
            clip = "hotwire",
            flag = 16
        }
    })

    if success then
        if math.random(100) <= Config.PoliceAlertChance then
            local jobData = Bridge.Framework.GetPlayerJobData()
            local policePlayerCount = 0

            for _, v in pairs(jobData) do
                if v and jobData.name ~= nil then
                    if not jobData or (jobData.name ~= "police" and jobData.name ~= "sheriff") then
                        Bridge.Notify.SendNotify(Bridge.Language.Locale("error.no_police"), 'error', 5000)
                        return
                    end
                    policePlayerCount = policePlayerCount + 1
                end
            end

            Bridge.Dispatch.SendAlert({
                message = Bridge.Language.Locale("info.police_alert"),
                code = "10-90",
                coords = entCoords,
                jobs = { "police", "sheriff" },
                blipData = {
                    sprite = 500,
                    color = 1,
                    scale = 1.0
                },
                alertTime = 300000, -- 5 minutes
                icon = "fas fa-exclamation-triangle"
            })
            Bridge.Notify.SendNotify(Bridge.Language.Locale("error.cops_called"), 'error', 5000)
        end

        TriggerServerEvent('cbd-meters:server:robmeter', GetEntityModel(entity))
        ClearPedTasks(ped)
        startCooldown()
    end
end

function BeginMiniGame(entity)
    if not DoesEntityExist(entity) then
        return Bridge.Notify.SendNotify(Bridge.Language.Locale('error.no_meter'), 'error',
            5000)
    end

    if Config.MiniGame == "ox" then
        local result = lib.skillCheck({ 'easy', 'easy', 'easy', 'easy' }, { 'w', 'a', 's', 'd' })
        return result
    elseif Config.MiniGame == "bagus" then
        local result = exports['lockpick']:startLockpick()
        return result
    elseif Config.MiniGame == "ps-ui" then
        local returnvalue = false
        exports['ps-ui']:Circle(function(success)
            if success then
                returnvalue = true
            else
                returnvalue = false
            end
        end, 3, 20000)
        return returnvalue
    elseif Config.MiniGame == "bl-progress" then
        local success = exports.bl_ui:Progress(3, 50)
        return success
    elseif Config.MiniGame == "bl-keyspam" then
        local success = exports.bl_ui:KeySpam(3, 50)
        return success
    elseif Config.MiniGame == "bl-circle" then
        local success = exports.bl_ui:CircleProgress(3, 50)
        return success
    elseif Config.MiniGame == "bl-printlock" then
        local success = exports.bl_ui:PrintLock(3, {
            grid = 4,
            duration = 5000,
            target = 4
        })
        return success
    elseif Config.MiniGame == "t3_lockpick" then
        local returnvalue = false
        local success = exports["t3_lockpick"]:startLockpick(1.0, 2, 5)
        if success then
            returnvalue = true
        else
            returnvalue = false
        end
        return returnvalue
    elseif Config.MiniGame == "bit-unlock" then
        -- untested, I dont own this to test
        local returnvalue = nil
        TriggerEvent("bit-unlock:start", "lockpick", "easy", function(success)
            if success then
                returnvalue = true
            else
                returnvalue = false
            end
        end)
        while returnvalue == nil do
            Wait(0)
        end
        return returnvalue
    elseif Config.MiniGame == "xmmx" then
        local success = exports.xmmx_circlesgame:StartCircleGame("medium", 50, "letters", "Test Game:")
        return success
    elseif Config.MiniGame == "rainmadlockpick" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:timedLockpick(200)
        return success or false
    elseif Config.MiniGame == "rainmadaction" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:timedAction(3)
        return success or false
    elseif Config.MiniGame == "rainmadquick" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:quickTimeEvent("easy")
        return success or false
    elseif Config.MiniGame == "rainmadmash" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:buttonMashing(5, 10)
        return success or false
    elseif Config.MiniGame == "rainmadangled" then
        -- he doesnt list if a bool is returned on false and closed my ticket when I asked.
        local success = exports['rm_minigames']:angledLockpick("easy")
        return success or false
    else
        return true
    end
end

RegisterNetEvent('community_bridge:Client:OnPlayerLoaded', function()
    Bridge.Target.AddModel(Config.meterModels, {
        {
            label = Bridge.Language.Locale('info.take_money'),
            icon = Bridge.Language.Locale('info.icon'),
            canInteract = function(entity)
                if onCooldown then return end
                if IsPedInAnyVehicle(PlayerPedId(), true) then return end
                if not DoesEntityExist(entity) then return end
                return verifyMeterStatus(entity)
            end,
            onSelect = function(entity)
                robMeter(entity)
            end,
            items = "screwdriverset",
            distance = 2
        }
    })
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    Bridge.Target.AddModel(Config.meterModels, {
        {
            label = Bridge.Language.Locale('info.take_money'),
            icon = Bridge.Language.Locale('info.icon'),
            canInteract = function(entity)
                if onCooldown then return end
                if IsPedInAnyVehicle(PlayerPedId(), true) then return end
                if not DoesEntityExist(entity) then return end
                return verifyMeterStatus(entity)
            end,
            onSelect = function(entity)
                robMeter(entity)
            end,
            items = "screwdriverset",
            distance = 2
        }
    })
end)

RegisterNetEvent('community_bridge:Client:OnPlayerUnload', function()
    Bridge.Target.RemoveModel(Config.meterModels)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Bridge.Target.RemoveModel(Config.meterModels)
    end
end)

RegisterNetEvent('cbd-meters:client:updateList', function(list)
    robbedMeters = list
end)
