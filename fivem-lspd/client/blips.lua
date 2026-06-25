-- ╔══════════════════════════════════════════════╗
--  LSPD — Blips & Zones de service
-- ╚══════════════════════════════════════════════╝

local activeBlips = {}
local activeZones = {}

-- ── Blips sur la carte ────────────────────────────
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

-- ── Zones d'interaction (ox_lib) ───────────────────
function InitZones()
    for zoneId, loc in pairs(Config.Locations) do

        -- Zone vestiaire — prise de service + tenues
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.clothingPoint,
            radius  = Config.SpawnDistance,
            debug   = false,
            onEnter = function()
                if not IsPolice() then return end
                local txt = IsOnDuty()
                    and '[E] Vestiaire / Fin de service'
                    or  '[E] Vestiaire / Prise de service'
                lib.showTextUI(txt, { position = 'left-center', icon = 'shirt' })
            end,
            onExit  = function() lib.hideTextUI() end,
            inside  = function()
                if not IsPolice() then return end
                if IsControlJustReleased(0, 38) then -- E
                    if IsOnDuty() then
                        OpenOutfitMenu()
                    else
                        ToggleDuty()
                    end
                end
            end,
        })

        -- Zone garage — véhicules uniquement depuis ici
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.vehiclePoint,
            radius  = Config.SpawnDistance,
            debug   = false,
            onEnter = function()
                if not IsPolice() or not IsOnDuty() then return end
                lib.showTextUI('[E] Garage LSPD', { position = 'left-center', icon = 'car' })
            end,
            onExit  = function() lib.hideTextUI() end,
            inside  = function()
                if not IsPolice() or not IsOnDuty() then return end
                if IsControlJustReleased(0, 38) then
                    OpenVehicleMenu()
                end
            end,
        })

        -- Zone armurerie
        activeZones[#activeZones + 1] = lib.zones.sphere({
            coords  = loc.armoryPoint,
            radius  = Config.SpawnDistance,
            debug   = false,
            onEnter = function()
                if not IsPolice() or not IsOnDuty() then return end
                lib.showTextUI('[E] Armurerie LSPD', { position = 'left-center', icon = 'gun' })
            end,
            onExit  = function() lib.hideTextUI() end,
            inside  = function()
                if not IsPolice() or not IsOnDuty() then return end
                if IsControlJustReleased(0, 38) then
                    OpenArmoryMenu()
                end
            end,
        })
    end
end
