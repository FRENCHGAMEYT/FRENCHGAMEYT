-- ════════════════════════════════════════════════
--  LSPD — Blips & Zones de service
-- ════════════════════════════════════════════════

local activeBlips = {}
local activeZones = {}

function InitBlips()
    for _, b in pairs(activeBlips) do RemoveBlip(b) end
    activeBlips = {}
    for _, loc in pairs(Config.Locations) do
        local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(blip, loc.blip.sprite)
        SetBlipColour(blip, loc.blip.color)
        SetBlipScale(blip, loc.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(loc.blip.label)
        EndTextCommandSetBlipName(blip)
        activeBlips[#activeBlips + 1] = blip
    end
end

function InitZones()
    for _, loc in pairs(Config.Locations) do
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.clothingPoint, radius = Config.SpawnDistance, debug = false,
            onEnter = function() lib.showTextUI('[' .. Config.MenuKey .. '] Vestiaire LSPD', { position = 'left-center', icon = 'shirt' }) end,
            onExit  = function() lib.hideTextUI() end,
            inside  = function()
                if IsControlJustReleased(0, GetControlIdForName('keyboard', Config.MenuKey)) then
                    if IsPolice() and IsOnDuty() then OpenOutfitMenu() end
                end
            end,
        })
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.vehiclePoint, radius = Config.SpawnDistance, debug = false,
            onEnter = function() lib.showTextUI('[' .. Config.MenuKey .. '] Garage LSPD', { position = 'left-center', icon = 'car' }) end,
            onExit  = function() lib.hideTextUI() end,
            inside  = function()
                if IsControlJustReleased(0, GetControlIdForName('keyboard', Config.MenuKey)) then
                    if IsPolice() and IsOnDuty() then OpenVehicleMenu() end
                end
            end,
        })
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.armoryPoint, radius = Config.SpawnDistance, debug = false,
            onEnter = function() lib.showTextUI('[' .. Config.MenuKey .. '] Armurerie LSPD', { position = 'left-center', icon = 'gun' }) end,
            onExit  = function() lib.hideTextUI() end,
            inside  = function()
                if IsControlJustReleased(0, GetControlIdForName('keyboard', Config.MenuKey)) then
                    if IsPolice() and IsOnDuty() then OpenArmoryMenu() end
                end
            end,
        })
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.dutyPoint, radius = Config.SpawnDistance, debug = false,
            onEnter = function() lib.showTextUI('[' .. Config.DutyKey .. '] Prise / Fin de service', { position = 'left-center', icon = 'shield-halved' }) end,
            onExit  = function() lib.hideTextUI() end,
        })
    end
end
