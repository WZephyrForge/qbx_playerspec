lib.callback.register('qbx_playerspec:client:openPspeccDialog', function()
    local input = lib.inputDialog('Speccing Rapport', {
        {
            type = 'number',
            label = 'Spiller ID',
            description = 'Din spiller ID',
            required = true,
            min = 1,
            max = 1000
        },
        {
            type = 'textarea',
            label = 'Beskrivelse',
            description = 'Hvorfor trenger du speccing?',
            required = true,
            rows = 4
        }
    })

    if not input then
        return false
    end

    return {
        targetId = input[1],
        description = input[2]
    }
end)
