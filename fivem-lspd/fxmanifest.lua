fx_version 'cerulean'
game 'gta5'

name        'fivem-lspd'
description 'Script LSPD complet — tenues, véhicules, unités spéciales, menu interactif'
author      'FrenchGameYT'
version     '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

client_scripts {
    'client/main.lua',
    'client/menu.lua',
    'client/clothing.lua',
    'client/vehicle.lua',
    'client/blips.lua',
    'client/nui.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/callbacks.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/app.js',
    'locales/fr.json',
    'locales/en.json',
}

lua54 'yes'
