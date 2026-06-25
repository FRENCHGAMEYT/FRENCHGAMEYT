-- ════════════════════════════════════════════════
--  LSPD — Callbacks Serveur
-- ════════════════════════════════════════════════

if Config.Framework == 'esx' then
    AddEventHandler('onServerResourceStart', function(res)
        if res ~= GetCurrentResourceName() then return end
        Citizen.Wait(200)
        ESX.RegisterServerCallback('lspd:getOnDuty', function(source, cb)
            cb(exports[GetCurrentResourceName()]:getOnDutyPlayers())
        end)
        ESX.RegisterServerCallback('lspd:getPlayerInfo', function(source, cb)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then cb(nil) return end
            cb({
                job   = xPlayer.getJob(),
                grade = xPlayer.getJob().grade,
            })
        end)
    end)
elseif Config.Framework == 'qb' then
    AddEventHandler('onServerResourceStart', function(res)
        if res ~= GetCurrentResourceName() then return end
        Citizen.Wait(200)
        QBCore.Functions.CreateCallback('lspd:getOnDuty', function(source, cb)
            cb(exports[GetCurrentResourceName()]:getOnDutyPlayers())
        end)
        QBCore.Functions.CreateCallback('lspd:getPlayerInfo', function(source, cb)
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player then cb(nil) return end
            cb({
                job   = Player.PlayerData.job,
                grade = Player.PlayerData.job.grade.level,
            })
        end)
    end)
end
