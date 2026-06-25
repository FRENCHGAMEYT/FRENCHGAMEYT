-- ════════════════════════════════════════════════
--  LSPD — Gestion des tenues
-- ════════════════════════════════════════════════

local savedOutfit = nil

local function isFemale()
    local model = GetEntityModel(PlayerPedId())
    return model == GetHashKey('mp_f_freemode_01')
        or model == GetHashKey('a_f_y_beach_01')
end

local function genderKey()
    return isFemale() and 'female' or 'male'
end

local function saveCurrentOutfit()
    local ped = PlayerPedId()
    savedOutfit = { components = {}, props = {} }
    for i = 0, 11 do
        savedOutfit.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture  = GetPedTextureVariation(ped, i),
        }
    end
    for i = 0, 6 do
        savedOutfit.props[i] = {
            drawable = GetPedPropIndex(ped, i),
            texture  = GetPedPropTextureIndex(ped, i),
        }
    end
end

function ApplyOutfit(outfitKey)
    local outfit = Config.Outfits[outfitKey]
    if not outfit then
        lib.notify({ title = 'LSPD', description = 'Tenue introuvable : ' .. outfitKey, type = 'error' })
        return
    end
    if not savedOutfit then saveCurrentOutfit() end
    local ped    = PlayerPedId()
    local gender = genderKey()
    for _, comp in ipairs(outfit.gender[gender] or {}) do
        SetPedComponentVariation(ped, comp.component, comp.drawable, comp.texture, 2)
    end
    for _, prop in ipairs(outfit.props[gender] or {}) do
        if prop.drawable == -1 then
            ClearPedProp(ped, prop.prop)
        else
            SetPedPropIndex(ped, prop.prop, prop.drawable, prop.texture, true)
        end
    end
    TriggerServerEvent('lspd:logOutfit', outfitKey)
end

function RemoveAllOutfit()
    if not savedOutfit then return end
    local ped = PlayerPedId()
    for i, comp in pairs(savedOutfit.components) do
        SetPedComponentVariation(ped, i, comp.drawable, comp.texture, 2)
    end
    for i, prop in pairs(savedOutfit.props) do
        if prop.drawable == -1 then
            ClearPedProp(ped, i)
        else
            SetPedPropIndex(ped, i, prop.drawable, prop.texture, true)
        end
    end
    savedOutfit = nil
end
