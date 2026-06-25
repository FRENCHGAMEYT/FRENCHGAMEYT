-- ════════════════════════════════════════════════
--  LSPD — Server Main
-- ════════════════════════════════════════════════

local onDutyPlayers = {}  -- [source] = { unit = string, since = timestamp }

-- ── Prise / fin de service ───────────────────────
RegisterNetEvent('lspd:setDuty', function(state)
    local src = source
    if state then
        onDutyPlayers[src] = { unit = nil, since = os.time() }
        TriggerClientEvent('lspd:onDutySync', src, true)
        NotifyPolice(src, '🟢 ' .. GetPlayerName(src) .. ' est en service.')
    else
        onDutyPlayers[src] = nil
        TriggerClientEvent('lspd:onDutySync', src, false)
        NotifyPolice(src, '🔴 ' .. GetPlayerName(src) .. ' a terminé son service.')
    end
    UpdateDutyDB(src, state)
end)

RegisterNetEvent('lspd:setUnit', function(unitId)
    local src = source
    if onDutyPlayers[src] then
        onDutyPlayers[src].unit = unitId
    end
end)

RegisterNetEvent('lspd:giveWeapon', function(weaponHash, ammo)
    local src = source
    if not IsPolice(src) then return end
    if ammo > 0 then
        GiveWeaponToPed(GetPlayerPed(src), GetHashKey(weaponHash), ammo, false, true)
    else
        GiveWeaponToPed(GetPlayerPed(src), GetHashKey(weaponHash), 1, false, false)
    end
    print('[LSPD] ' .. GetPlayerName(src) .. ' a obtenu ' .. weaponHash)
end)

RegisterNetEvent('lspd:removeWeapons', function()
    local src = source
    if not IsPolice(src) then return end
    RemoveAllPedWeapons(GetPlayerPed(src), true)
end)

RegisterNetEvent('lspd:logOutfit', function(outfitKey)
    local src = source
    print('[LSPD] ' .. GetPlayerName(src) .. ' a enfilé la tenue : ' .. outfitKey)
end)

RegisterNetEvent('lspd:logVehicle', function(model, plate)
    local src = source
    print('[LSPD] ' .. GetPlayerName(src) .. ' a spawné : ' .. model .. ' (' .. plate .. ')')
end)

-- ── Actions police ───────────────────────────────
RegisterNetEvent('lspd:searchPlayer', function(targetSrc)
    local src = source
    if not IsPolice(src) then return end
    TriggerClientEvent('ox_lib:notify', targetSrc, {
        title = 'LSPD', description = GetPlayerName(src) .. ' vous fouille.', type = 'inform', duration = 5000,
    })
    print('[LSPD] ' .. GetPlayerName(src) .. ' a fouillé ' .. GetPlayerName(targetSrc))
end)

RegisterNetEvent('lspd:handcuff', function(targetSrc, state)
    local src = source
    if not IsPolice(src) then return end
    TriggerClientEvent('lspd:applyHandcuff', targetSrc, state)
    print('[LSPD] ' .. GetPlayerName(src) .. (state and ' a menotté ' or ' a libéré ') .. GetPlayerName(targetSrc))
end)

RegisterNetEvent('lspd:getIdentity', function(targetSrc)
    local src = source
    if not IsPolice(src) then return end
    local identifier = GetPlayerIdentifier(targetSrc, 0) or 'inconnu'
    TriggerClientEvent('lspd:receiveIdentity', src, {
        name = GetPlayerName(targetSrc),
        id   = identifier,
        date = os.date('%d/%m/%Y %H:%M'),
    })
end)

RegisterNetEvent('lspd:impound', function(plate)
    local src = source
    if not IsPolice(src) then return end
    print('[LSPD] ' .. GetPlayerName(src) .. ' a mis en fourrière : ' .. plate)
end)

RegisterNetEvent('lspd:radarLog', function()
    local src = source
    print('[LSPD] ' .. GetPlayerName(src) .. ' a posé un radar.')
end)

function IsPolice(src)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.getJob().name == Config.JobName
    elseif Config.Framework == 'qb' then
        local Player = QBCore.Functions.GetPlayer(src)
        return Player and Player.PlayerData.job.name == Config.JobName
    end
    return true
end

function NotifyPolice(exceptSrc, message)
    for s, _ in pairs(onDutyPlayers) do
        if s ~= exceptSrc then
            TriggerClientEvent('ox_lib:notify', s, {
                title       = 'LSPD Radio',
                description = message,
                type        = 'inform',
                duration    = 5000,
            })
        end
    end
end

function UpdateDutyDB(src, state)
    if not MySQL then return end
    local identifier = GetPlayerIdentifier(src, 0) or ''
    MySQL.update('UPDATE users SET lspd_duty = ? WHERE identifier = ?',
        { state and 1 or 0, identifier })
end

exports('getOnDutyPlayers', function()
    local result = {}
    for src, data in pairs(onDutyPlayers) do
        result[src] = {
            name  = GetPlayerName(src),
            unit  = data.unit,
            since = data.since,
        }
    end
    return result
end)

AddEventHandler('playerDropped', function()
    local src = source
    onDutyPlayers[src] = nil
end)

AddEventHandler('onServerResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Citizen.Wait(100)
    if Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
    print('[LSPD] Ressource démarrée — Framework : ' .. Config.Framework)
end)
