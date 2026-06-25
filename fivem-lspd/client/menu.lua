-- ════════════════════════════════════════════════
--  LSPD — Menu Interactif (ox_lib context menu)
-- ════════════════════════════════════════════════

function OpenMainMenu()
    local unitLabel = GetCurrentUnit() and GetCurrentUnit().label or 'Aucune'
    local dutyTxt   = IsOnDuty() and '🟢 En service' or '🔴 Hors service'
    lib.registerContext({
        id = 'lspd_main', title = '🚔 Menu LSPD — ' .. GetGradeLabel(),
        options = {
            { title = dutyTxt, description = 'Basculer la prise/fin de service', icon = 'shield-halved', onSelect = function() ToggleDuty() end },
            { title = '👤 Unités spéciales', description = 'Choisir votre unité (' .. unitLabel .. ')', icon = 'users', disabled = not IsOnDuty(), onSelect = function() OpenUnitMenu() end },
            { title = '👕 Vestiaire', description = 'Changer de tenue', icon = 'shirt', disabled = not IsOnDuty(), onSelect = function() OpenOutfitMenu() end },
            { title = '🚗 Garage', description = 'Spawner un véhicule de service', icon = 'car', disabled = not IsOnDuty(), onSelect = function() OpenVehicleMenu() end },
            { title = '🔫 Armurerie', description = 'Récupérer vos armes de service', icon = 'gun', disabled = not IsOnDuty(), onSelect = function() OpenArmoryMenu() end },
            { title = '📋 Informations', description = 'Afficher vos informations d\'agent', icon = 'id-card', onSelect = function() OpenInfoMenu() end },
        },
    })
    lib.showContext('lspd_main')
end

function OpenUnitMenu()
    local grade = GetGrade()
    local options = { { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenMainMenu() end } }
    for _, unit in ipairs(Config.Units) do
        local locked  = grade < unit.minGrade
        local current = GetCurrentUnit() and GetCurrentUnit().id == unit.id
        options[#options + 1] = {
            title = unit.icon .. ' ' .. unit.label .. (current and ' ✓' or ''),
            description = unit.description .. (locked and '\n🔒 Nécessite : ' .. Config.Grades[unit.minGrade].label or ''),
            disabled = locked,
            onSelect = function()
                if locked then return end
                SetCurrentUnit(unit)
                lib.notify({ title = 'LSPD', description = 'Unité : ' .. unit.label, type = 'success' })
                local map = { patrol='patrol', detective='detective', swat='swat', doa='doa', mounted='motorcycle', k9='patrol', air='air' }
                ApplyOutfit(map[unit.id] or 'patrol')
                TriggerServerEvent('lspd:setUnit', unit.id)
            end,
        }
    end
    lib.registerContext({ id = 'lspd_unit', title = '🎖️ Choisir une unité', options = options })
    lib.showContext('lspd_unit')
end

function OpenOutfitMenu()
    local options = { { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenMainMenu() end } }
    for key, outfit in pairs(Config.Outfits) do
        options[#options + 1] = {
            title = '👔 ' .. outfit.label, description = 'Appliquer la tenue ' .. outfit.label,
            onSelect = function() ApplyOutfit(key) lib.notify({ title='LSPD', description='Tenue : '..outfit.label, type='success' }) end,
        }
    end
    options[#options + 1] = { title = '👕 Tenue civile', description = 'Retirer la tenue de service', icon = 'person',
        onSelect = function() RemoveAllOutfit() lib.notify({ title='LSPD', description='Tenue civile.', type='inform' }) end }
    lib.registerContext({ id = 'lspd_outfit', title = '👕 Vestiaire LSPD', options = options })
    lib.showContext('lspd_outfit')
end

function OpenVehicleMenu()
    local unit = GetCurrentUnit()
    local options = { { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenMainMenu() end } }
    if unit and Config.Vehicles[unit.id] then
        local cat = Config.Vehicles[unit.id]
        options[#options + 1] = { title = unit.icon .. ' ' .. cat.label .. ' (unité actuelle)', icon = 'star',
            onSelect = function() OpenVehicleCategory(unit.id, cat) end }
    end
    for catId, cat in pairs(Config.Vehicles) do
        if not (unit and catId == unit.id) then
            options[#options + 1] = { title = '🚗 ' .. cat.label, description = #cat.vehicles .. ' véhicule(s)',
                onSelect = function() OpenVehicleCategory(catId, cat) end }
        end
    end
    if GetSpawnedVehicle() and DoesEntityExist(GetSpawnedVehicle()) then
        options[#options + 1] = { title = '🗑️ Supprimer mon véhicule', icon = 'trash',
            onSelect = function() DeleteVehicle(GetSpawnedVehicle()) SetSpawnedVehicle(nil) lib.notify({ title='LSPD', description='Véhicule supprimé.', type='inform' }) end }
    end
    lib.registerContext({ id = 'lspd_garage', title = '🚗 Garage LSPD', options = options })
    lib.showContext('lspd_garage')
end

function OpenVehicleCategory(catId, cat)
    local options = { { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenVehicleMenu() end } }
    for _, v in ipairs(cat.vehicles) do
        options[#options + 1] = { title = v.label, description = 'Modèle : ' .. v.model .. ' | Plaque : ' .. v.plate, icon = 'car',
            onSelect = function() SpawnVehicle(v) end }
    end
    lib.registerContext({ id = 'lspd_veh_cat', title = '🚗 ' .. cat.label, options = options })
    lib.showContext('lspd_veh_cat')
end

function OpenArmoryMenu()
    local grade = GetGrade()
    local options = { { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenMainMenu() end } }
    for _, weapon in ipairs(Config.Armory) do
        local locked = grade < weapon.minGrade
        options[#options + 1] = {
            title = (locked and '🔒 ' or '🔫 ') .. weapon.label,
            description = (weapon.ammo > 0 and weapon.ammo .. ' munitions' or 'Corps à corps')
                          .. (locked and '\nNécessite : ' .. Config.Grades[weapon.minGrade].label or ''),
            disabled = locked,
            onSelect = function()
                if locked then return end
                TriggerServerEvent('lspd:giveWeapon', weapon.weapon, weapon.ammo)
                lib.notify({ title='LSPD', description=weapon.label..' obtenu.', type='success' })
            end,
        }
    end
    options[#options + 1] = { title = '🗑️ Rendre toutes les armes', icon = 'trash',
        onSelect = function() TriggerServerEvent('lspd:removeWeapons') lib.notify({ title='LSPD', description='Armes rendues.', type='inform' }) end }
    lib.registerContext({ id = 'lspd_armory', title = '🔫 Armurerie LSPD', options = options })
    lib.showContext('lspd_armory')
end

function OpenInfoMenu()
    local unit = GetCurrentUnit()
    lib.registerContext({
        id = 'lspd_info', title = '📋 Informations Agent',
        options = {
            { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenMainMenu() end },
            { title = 'Grade',     description = GetGradeLabel() .. ' (Grade ' .. GetGrade() .. ')', icon = 'medal',        disabled = true },
            { title = 'Statut',    description = IsOnDuty() and 'En service ✅' or 'Hors service ❌',  icon = 'circle-info', disabled = true },
            { title = 'Unité',     description = unit and (unit.icon..' '..unit.label) or 'Aucune unité', icon = 'users',   disabled = true },
            { title = 'Matricule', description = 'LSPD-' .. tostring(GetPlayerServerId(PlayerId())), icon = 'id-badge',    disabled = true },
        },
    })
    lib.showContext('lspd_info')
end
