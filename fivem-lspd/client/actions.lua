-- ╔══════════════════════════════════════════════╗
--  LSPD — Actions police (F6)
-- ╚══════════════════════════════════════════════╝

local handcuffedPlayers = {}
local spikeStrip        = nil

-- ── Helpers ───────────────────────────────────────
local function getClosestPlayer(maxDist)
    maxDist = maxDist or 3.5
    local myPed = PlayerPedId()
    local myPos = GetEntityCoords(myPed)
    local closest, closestDist = -1, maxDist + 1

    for _, pid in ipairs(GetActivePlayers()) do
        if pid ~= PlayerId() then
            local ped  = GetPlayerPed(pid)
            local dist = #(myPos - GetEntityCoords(ped))
            if dist < closestDist then
                closest     = pid
                closestDist = dist
            end
        end
    end
    return closest ~= -1 and closest or nil
end

local function playAnim(dict, anim, dur)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
    TaskPlayAnim(PlayerPedId(), dict, anim, 3.0, 3.0, dur or 2000, 0, 0, false, false, false)
    Citizen.Wait(dur or 2000)
    ClearPedTasks(PlayerPedId())
end

-- ── Fouille ──────────────────────────────────────
function PoliceSearch()
    local target = getClosestPlayer(3.0)
    if not target then
        lib.notify({ title = 'LSPD', description = 'Aucun joueur à proximité.', type = 'error' })
        return
    end
    playAnim('mp_common', 'givetake1_a', 2500)
    TriggerServerEvent('lspd:searchPlayer', GetPlayerServerId(target))
    lib.notify({ title = 'LSPD', description = 'Fouille effectuée sur ' .. GetPlayerName(target) .. '.', type = 'inform' })
end

-- ── Menottes ─────────────────────────────────────
function PoliceHandcuff()
    local target = getClosestPlayer(2.5)
    if not target then
        lib.notify({ title = 'LSPD', description = 'Aucun joueur à proximité.', type = 'error' })
        return
    end
    local targetId = GetPlayerServerId(target)
    TriggerServerEvent('lspd:handcuff', targetId, true)
    handcuffedPlayers[targetId] = true
    lib.notify({ title = 'LSPD', description = GetPlayerName(target) .. ' est menotté.', type = 'success' })
end

-- ── Libérer ───────────────────────────────────────
function PoliceUnhandcuff()
    local target = getClosestPlayer(2.5)
    if not target then
        lib.notify({ title = 'LSPD', description = 'Aucun joueur à proximité.', type = 'error' })
        return
    end
    local targetId = GetPlayerServerId(target)
    TriggerServerEvent('lspd:handcuff', targetId, false)
    handcuffedPlayers[targetId] = nil
    lib.notify({ title = 'LSPD', description = GetPlayerName(target) .. ' est libéré.', type = 'inform' })
end

-- ── Contrôle d'identité ──────────────────────────
function PoliceIdentity()
    local target = getClosestPlayer(3.0)
    if not target then
        lib.notify({ title = 'LSPD', description = 'Aucun joueur à proximité.', type = 'error' })
        return
    end
    TriggerServerEvent('lspd:getIdentity', GetPlayerServerId(target))
end

RegisterNetEvent('lspd:receiveIdentity', function(info)
    lib.alertDialog({
        header  = '🪪 Contrôle d\'identité',
        content = '**Nom :** ' .. info.name ..
                  '\n**Matricule :** ' .. info.id ..
                  '\n**Date :** ' .. info.date,
        cancel  = false,
    })
end)

-- ── Radar vitesse ─────────────────────────────────
function PoliceRadar()
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local model = `prop_roadcone02a`
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end

    local obj = CreateObjectNoOffset(model,
        coords.x + math.cos(math.rad(heading)) * 1.5,
        coords.y + math.sin(math.rad(heading)) * 1.5,
        coords.z, true, true, false)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)

    lib.notify({ title = 'LSPD', description = 'Radar positionné.', type = 'success' })
    TriggerServerEvent('lspd:radarLog')

    -- auto-remove after 5 min
    SetTimeout(300000, function()
        if DoesEntityExist(obj) then DeleteObject(obj) end
    end)
end

-- ── Crocheter véhicule ────────────────────────────
function PoliceLockpick()
    local ped = PlayerPedId()
    local veh = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)

    if not DoesEntityExist(veh) then
        lib.notify({ title = 'LSPD', description = 'Aucun véhicule à proximité.', type = 'error' })
        return
    end

    lib.notify({ title = 'LSPD', description = 'Crochetage en cours...', type = 'inform' })
    playAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 3000)
    SetVehicleDoorsLocked(veh, 1)
    lib.notify({ title = 'LSPD', description = 'Véhicule ouvert.', type = 'success' })
end

-- ── Fourrière ─────────────────────────────────────
function PoliceImpound()
    local ped = PlayerPedId()
    local veh = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)

    if not DoesEntityExist(veh) then
        lib.notify({ title = 'LSPD', description = 'Aucun véhicule à proximité.', type = 'error' })
        return
    end

    local confirmed = lib.alertDialog({
        header  = '🚗 Mise en fourrière',
        content = 'Confirmer la mise en fourrière de ce véhicule ?',
        cancel  = true,
        labels  = { confirm = 'Confirmer', cancel = 'Annuler' },
    })
    if confirmed ~= 'confirm' then return end

    local plate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent('lspd:impound', plate)
    DeleteVehicle(veh)
    lib.notify({ title = 'LSPD', description = 'Véhicule ' .. plate .. ' mis en fourrière.', type = 'success' })
end

-- ── Hérissons ─────────────────────────────────────
function PoliceSpike()
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    if spikeStrip and DoesEntityExist(spikeStrip) then
        DeleteObject(spikeStrip)
        spikeStrip = nil
        lib.notify({ title = 'LSPD', description = 'Hérissons retirés.', type = 'inform' })
        return
    end

    local model = `prop_ld_stinger_s`
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end

    spikeStrip = CreateObjectNoOffset(model,
        coords.x + math.cos(math.rad(heading)) * 2.0,
        coords.y + math.sin(math.rad(heading)) * 2.0,
        coords.z, true, true, false)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(spikeStrip)
    SetEntityHeading(spikeStrip, heading + 90.0)

    lib.notify({ title = 'LSPD', description = 'Hérissons déployés. Appuyer à nouveau pour retirer.', type = 'success' })
end

-- ── Réception menottes côté cible ─────────────────
RegisterNetEvent('lspd:applyHandcuff', function(state)
    local ped = PlayerPedId()
    if state then
        TaskHandsUp(ped, -1, 0, -1, false)
        FreezeEntityPosition(ped, true)
        lib.notify({ title = 'LSPD', description = 'Vous avez été menotté.', type = 'error' })
    else
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)
        lib.notify({ title = 'LSPD', description = 'Vous avez été libéré.', type = 'success' })
    end
end)
