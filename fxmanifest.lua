fx_version 'cerulean'
game 'gta5'
author 'ChristianBDev'
description 'Parking Meter robbery script'
version '1.0.0'

client_scripts {
	'client/main.lua',
	'config.lua'
}
server_scripts {
	'server/main.lua',
	'config.lua'
}

shared_scripts {
	'@qb-core/shared/locale.lua',
	'@ox_lib/init.lua',
	'config.lua',
	'locales/*.lua',
}

lua54 'yes'
