-- ════════════════════════════════════════════════
--  LSPD — NUI Callbacks (Lua <-> JS)
-- ════════════════════════════════════════════════

function OpenNUIMenu()
    if not IsPolice() then
        lib.notify({ title = 'LSPD', description = 'Accès refusé.', type = 'error' })
        return
    end
    local grade = GetGrade()
    local unitsData = {}
    for _, unit in ipairs(Config.Units) do
        unitsData[#unitsData + 1] = {
            id = unit.id, label = unit.label, description = unit.description,
            icon = unit.icon, minGrade = unit.minGrade, color = unit.color,
            minGradeLabel = Config.Grades[unit.minGrade] and Config.Grades[unit.minGrade].label or '',
        }
    end
    local outfitsData = {}
    for key, outfit in pairs(Config.Outfits) do
        outfitsData[#outfitsData + 1] = { key = key, label = outfit.label }
    end
    local vehiclesData = {}
    for catId, cat in pairs(Config.Vehicles) do
        vehiclesData[catId] = { label = cat.label, vehicles = cat.vehicles }
    end
    local armoryData = {}
    for _, weapon in ipairs(Config.Armory) do
        armoryData[#armoryData + 1] = { weapon = weapon.weapon, label = weapon.label, ammo = weapon.ammo, minGrade = weapon.minGrade }
    end
    SendNUIMessage({
        action = 'openMenu',
        data = {
            onDuty = IsOnDuty(), grade = grade, gradeLabel = GetGradeLabel(),
            currentUnit = GetCurrentUnit(),
            matricule = 'LSPD-' .. tostring(GetPlayerServerId(PlayerId())),
            units = unitsData, outfits = outfitsData, vehicles = vehiclesData, armory = armoryData,
        },
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('closeMenu',    function(_, cb) SetNuiFocus(false, false) cb('ok') end)
RegisterNUICallback('toggleDuty',   function(_, cb) ToggleDuty() cb('ok') end)
RegisterNUICallback('selectUnit', function(data, cb)
    for _, unit in ipairs(Config.Units) do
        if unit.id == data.unitId then
            SetCurrentUnit(unit)
            TriggerServerEvent('lspd:setUnit', unit.id)
            lib.notify({ title = 'LSPD', description = 'Unité : ' .. unit.label, type = 'success' })
            local map = { patrol='patrol', detective='detective', swat='swat', doa='doa', mounted='motorcycle', k9='patrol', air='air' }
            ApplyOutfit(map[unit.id] or 'patrol')
            break
        end
    end
    cb('ok')
end)
RegisterNUICallback('applyOutfit',  function(data, cb) ApplyOutfit(data.outfitKey) lib.notify({ title='LSPD', description='Tenue appliquée.', type='success' }) cb('ok') end)
RegisterNUICallback('removeOutfit', function(_, cb)   RemoveAllOutfit() lib.notify({ title='LSPD', description='Tenue civile.', type='inform' }) cb('ok') end)
RegisterNUICallback('spawnVehicle', function(data, cb) SpawnVehicle(data.vehicleData) cb('ok') end)
RegisterNUICallback('giveWeapon',   function(data, cb) TriggerServerEvent('lspd:giveWeapon', data.weapon, data.ammo) lib.notify({ title='LSPD', description='Arme obtenue.', type='success' }) cb('ok') end)
RegisterNUICallback('removeWeapons',function(_, cb)   TriggerServerEvent('lspd:removeWeapons') lib.notify({ title='LSPD', description='Armes rendues.', type='inform' }) cb('ok') end)

RegisterCommand('lspdui', function() OpenNUIMenu() end, false)
