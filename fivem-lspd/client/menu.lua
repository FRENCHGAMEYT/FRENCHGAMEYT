-- ╔══════════════════════════════════════════════╗
--  LSPD — Menus ox_lib (zones)
-- ╚══════════════════════════════════════════════╝

-- ── Vestiaire — choisir tenue = prise de service ──
function OpenOutfitMenu()
    if not IsPolice() then return end

    local options = {}
    for key, outfit in pairs(Config.Outfits) do
        local k = key
        options[#options + 1] = {
            title       = '👔 ' .. outfit.label,
            description = 'Enfiler la tenue de service',
            onSelect    = function()
                if not IsOnDuty() then
                    ToggleDuty()
                end
                ApplyOutfit(k)
                lib.notify({ title = 'LSPD', description = 'Tenue : ' .. outfit.label .. ' | Service activé.', type = 'success' })
            end,
        }
    end

    if IsOnDuty() then
        options[#options + 1] = {
            title       = '👕 Tenue civile / Fin de service',
            description = 'Retirer la tenue — termine le service',
            icon        = 'person',
            onSelect    = function()
                RemoveAllOutfit()
                if IsOnDuty() then ToggleDuty() end
            end,
        }
    end

    lib.registerContext({ id = 'lspd_outfit', title = '👕 Vestiaire LSPD', options = options })
    lib.showContext('lspd_outfit')
end

-- ── Armurerie ─────────────────────────────────────
function OpenArmoryMenu()
    if not IsPolice() or not IsOnDuty() then return end
    local grade   = GetGrade()
    local options = {}

    for _, weapon in ipairs(Config.Armory) do
        local locked = grade < weapon.minGrade
        local w = weapon
        options[#options + 1] = {
            title       = (locked and '🔒 ' or '🔫 ') .. weapon.label,
            description = (weapon.ammo > 0 and weapon.ammo .. ' munitions' or 'Corps à corps')
                          .. (locked and '\nNécessite : ' .. (Config.Grades[weapon.minGrade] and Config.Grades[weapon.minGrade].label or '') or ''),
            disabled    = locked,
            onSelect    = function()
                TriggerServerEvent('lspd:giveWeapon', w.weapon, w.ammo)
                lib.notify({ title = 'LSPD', description = w.label .. ' obtenu.', type = 'success' })
            end,
        }
    end

    options[#options + 1] = {
        title    = '🗑️ Rendre toutes les armes',
        icon     = 'trash',
        onSelect = function()
            TriggerServerEvent('lspd:removeWeapons')
            lib.notify({ title = 'LSPD', description = 'Armes rendues.', type = 'inform' })
        end,
    }

    lib.registerContext({ id = 'lspd_armory', title = '🔫 Armurerie LSPD', options = options })
    lib.showContext('lspd_armory')
end

-- ── Garage ────────────────────────────────────────
function OpenVehicleMenu()
    if not IsPolice() or not IsOnDuty() then return end
    local options = {}

    for catId, cat in pairs(Config.Vehicles) do
        local cId = catId
        local c   = cat
        options[#options + 1] = {
            title       = '🚗 ' .. cat.label,
            description = #cat.vehicles .. ' véhicule(s)',
            onSelect    = function() OpenVehicleCategory(cId, c) end,
        }
    end

    if GetSpawnedVehicle() and DoesEntityExist(GetSpawnedVehicle()) then
        options[#options + 1] = {
            title    = '🗑️ Supprimer mon véhicule',
            icon     = 'trash',
            onSelect = function()
                DeleteVehicle(GetSpawnedVehicle())
                SetSpawnedVehicle(nil)
                lib.notify({ title = 'LSPD', description = 'Véhicule supprimé.', type = 'inform' })
            end,
        }
    end

    lib.registerContext({ id = 'lspd_garage', title = '🚗 Garage LSPD', options = options })
    lib.showContext('lspd_garage')
end

function OpenVehicleCategory(catId, cat)
    local options = {
        { title = '← Retour', icon = 'arrow-left', onSelect = function() OpenVehicleMenu() end },
    }
    for _, v in ipairs(cat.vehicles) do
        local vv = v
        options[#options + 1] = {
            title       = vv.label,
            description = 'Modèle : ' .. vv.model .. ' | Plaque : ' .. vv.plate,
            icon        = 'car',
            onSelect    = function() SpawnVehicle(vv) end,
        }
    end
    lib.registerContext({ id = 'lspd_veh_cat', title = '🚗 ' .. cat.label, options = options })
    lib.showContext('lspd_veh_cat')
end
