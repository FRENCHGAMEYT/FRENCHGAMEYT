-- ╔══════════════════════════════════════════════╗
--  LSPD — NUI (F6 outils police)
-- ╚══════════════════════════════════════════════╝

function OpenNUIMenu()
    if not IsPolice() or not IsOnDuty() then return end

    SendNUIMessage({
        action = 'openMenu',
        data   = {
            onDuty     = true,
            grade      = GetGrade(),
            gradeLabel = GetGradeLabel(),
            matricule  = 'LSPD-' .. tostring(GetPlayerServerId(PlayerId())),
        },
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('closeMenu', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- ── Dispatcher des actions police ─────────────────
RegisterNUICallback('policeAction', function(data, cb)
    local action = data.action
    if     action == 'search'     then PoliceSearch()
    elseif action == 'handcuff'   then PoliceHandcuff()
    elseif action == 'unhandcuff' then PoliceUnhandcuff()
    elseif action == 'identity'   then PoliceIdentity()
    elseif action == 'radar'      then PoliceRadar()
    elseif action == 'lockpick'   then PoliceLockpick()
    elseif action == 'impound'    then PoliceImpound()
    elseif action == 'spike'      then PoliceSpike()
    end
    cb('ok')
end)
