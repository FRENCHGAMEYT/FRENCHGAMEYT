-- ╔══════════════════════════════════════════════╗
--  LSPD — Client Main
-- ╚══════════════════════════════════════════════╝

local playerData   = {}
local isOnDuty     = false
local currentUnit  = nil
local spawnedVehicle = nil

-- ── Initialisation selon le framework ────────────
local function initFramework()
    if Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        ESX.RegisterNUICallback('dummy', function() end)

        RegisterNetEvent('esx:playerLoaded', function(xPlayer)
            playerData = xPlayer
            TriggerEvent('lspd:refreshPlayerData', xPlayer)
        end)

        RegisterNetEvent('esx:setJob', function(job)
            playerData.job = job
            TriggerEvent('lspd:refreshPlayerData', playerData)
        end)

    elseif Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()

        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            playerData = QBCore.Functions.GetPlayerData()
        end)

        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobInfo)
            playerData.job = jobInfo
        end)
    end
end

-- ── Helpers ────────────────────────────────────────
function GetPlayerJob()
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerData()
        return xPlayer and xPlayer.job or nil
    elseif Config.Framework == 'qb' then
        local pd = QBCore.Functions.GetPlayerData()
        return pd and pd.job or nil
    end
    return nil
end

function IsPolice()
    local job = GetPlayerJob()
    return job and job.name == Config.JobName
end

function GetGrade()
    local job = GetPlayerJob()
    if job then
        return Config.Framework == 'esx' and job.grade or job.grade.level
    end
    return 0
end

function GetGradeLabel()
    local grade = GetGrade()
    return Config.Grades[grade] and Config.Grades[grade].label or 'Inconnu'
end

-- ── Prise / fin de service ───────────────────────
function ToggleDuty()
    if not IsPolice() then return end

    isOnDuty = not isOnDuty
    TriggerServerEvent('lspd:setDuty', isOnDuty)

    if isOnDuty then
        lib.notify({
            title       = 'LSPD',
            description = 'Vous êtes maintenant en service.',
            type        = 'success',
            duration    = 4000,
        })
        TriggerEvent('lspd:onDuty')
    else
        lib.notify({
            title       = 'LSPD',
            description = 'Vous avez terminé votre service.',
            type        = 'inform',
            duration    = 4000,
        })
        TriggerEvent('lspd:offDuty')
        currentUnit = nil
        RemoveAllOutfit()
    end
end

-- ── Touche de service ────────────────────────────
RegisterCommand('lspdduty', function()
    ToggleDuty()
end, false)

RegisterKeyMapping('lspdduty', 'LSPD — Prise / fin de service', 'keyboard', Config.DutyKey)

-- ── Touche menu ──────────────────────────────────
RegisterCommand('lspdmenu', function()
    if not IsPolice() then return end
    OpenMainMenu()
end, false)

RegisterKeyMapping('lspdmenu', 'LSPD — Menu Principal', 'keyboard', Config.MenuKey)

-- ── Événements ───────────────────────────────────
RegisterNetEvent('lspd:onDutySync', function(state)
    isOnDuty = state
end)

-- ── Getters exposés ──────────────────────────────
function IsOnDuty()   return isOnDuty   end
function GetCurrentUnit() return currentUnit end
function SetCurrentUnit(u) currentUnit = u end
function GetSpawnedVehicle() return spawnedVehicle end
function SetSpawnedVehicle(v) spawnedVehicle = v end

-- ── Démarrage ─────────────────────────────────────
AddEventHandler('onClientResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Citizen.Wait(500)
    initFramework()
    InitBlips()
    InitZones()
end)
