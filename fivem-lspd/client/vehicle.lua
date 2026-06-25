-- ════════════════════════════════════════════════
--  LSPD — Spawn / gestion des véhicules
-- ════════════════════════════════════════════════

local function getSpawnCoords()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local nearest, nearestDist = nil, math.huge
    for _, loc in pairs(Config.Locations) do
        local dist = #(playerCoords - loc.vehiclePoint)
        if dist < nearestDist then
            nearestDist = dist
            nearest     = loc
        end
    end
    if nearestDist > 500.0 then
        local forward = GetEntityForwardVector(PlayerPedId())
        return playerCoords + (forward * 5.0), GetEntityHeading(PlayerPedId())
    end
    return nearest.vehiclePoint, nearest.vehicleHeading
end

function SpawnVehicle(vehicleData)
    local model = GetHashKey(vehicleData.model)
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        lib.notify({ title = 'LSPD', description = 'Modèle introuvable : ' .. vehicleData.model, type = 'error' })
        return
    end
    local old = GetSpawnedVehicle()
    if old and DoesEntityExist(old) then DeleteVehicle(old) end
    lib.notify({ title = 'LSPD', description = 'Véhicule en cours de spawn…', type = 'inform', duration = 2000 })
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do
        Citizen.Wait(50)
        timeout = timeout + 1
    end
    if not HasModelLoaded(model) then
        lib.notify({ title = 'LSPD', description = 'Impossible de charger le modèle.', type = 'error' })
        return
    end
    local coords, heading = getSpawnCoords()
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleNumberPlateText(veh, vehicleData.plate)
    SetVehicleColours(veh, vehicleData.color1, vehicleData.color2)
    SetVehicleOnGroundProperly(veh)
    SetVehicleFuelLevel(veh, 100.0)
    SetVehicleEngineHealth(veh, 1000.0)
    SetVehicleBodyHealth(veh, 1000.0)
    if vehicleData.extras then
        for extId, state in pairs(vehicleData.extras) do
            SetVehicleExtra(veh, extId, state and 0 or 1)
        end
    end
    SetSpawnedVehicle(veh)
    SetModelAsNoLongerNeeded(model)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    lib.notify({ title = 'LSPD', description = vehicleData.label .. ' spawné.', type = 'success' })
    TriggerServerEvent('lspd:logVehicle', vehicleData.model, vehicleData.plate)
end
