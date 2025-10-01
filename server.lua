local config = require '@qbx_core/config/server'
local logger = require '@qbx_core/modules/logger'

local notificationsEnabled = true

lib.addCommand('pspecc', {
    help = 'Rapporter regelbrudd for speccing',
}, function(source)
    local adminName = GetPlayerName(source) or ('ID: %s'):format(source)

    local input = lib.callback.await('qbx_playerspec:client:openPspeccDialog', source)
    if not input then
        exports.qbx_core:Notify(source, 'Manglende argumenter', 'error')
        return
    end

    local targetId = tonumber(input.targetId)
    local description = tostring(input.description or '')

    if not targetId or description == '' then
        exports.qbx_core:Notify(source, 'Manglende argumenter', 'error')
        return
    end

    local targetPlayer = exports.qbx_core:GetPlayer(targetId)
    if not targetPlayer then
        exports.qbx_core:Notify(source, 'Spilleren er ikke online', 'error')
        return
    end

    local targetName = GetPlayerName(targetPlayer.PlayerData.source) or ('ID: %s'):format(targetPlayer.PlayerData.source)

    if notificationsEnabled then
        local players = GetPlayers()
        for _, src in pairs(players) do
            src = tonumber(src)
            if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'mod') then
                exports.qbx_core:Notify(src, ('🚨 Speccing Rapport: %s (ID: %s) trenger speccing! Beskrivelse: %s'):format(targetName, targetPlayer.PlayerData.source, description), 'warning', 10000)
            end
        end
    end

    logger.log({
        source = 'qbx_playerspec',
        webhook = config.logging.webhook['pspecc'],
        event = 'Spactate Rapport',
        color = 'yellow',
        message = (
            '**Hvem rapporterer:** %s (ID: %s)\n**Beskrivelse:** %s'
        ):format(targetName, targetPlayer.PlayerData.source, description)
    })

    exports.qbx_core:Notify(source, 'Takk! Rapporten er sendt til staff.', 'success')
end)

lib.addCommand('togglespecnotify', {
    help = 'Slå av/på speccing notifikasjoner (for streaming)',
    restricted = 'group.admin'
}, function(source)
    notificationsEnabled = not notificationsEnabled
    local statusMessage = notificationsEnabled and 'Speccing notifikasjoner er nå AKTIVERT' or 'Speccing notifikasjoner er nå DEAKTIVERT'
    
    local players = GetPlayers()
    for _, src in pairs(players) do
        src = tonumber(src)
        if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'mod') then
            exports.qbx_core:Notify(src, ('🔔 %s av %s'):format(statusMessage, GetPlayerName(source)), notificationsEnabled and 'success' or 'warning')
        end
    end
end)
