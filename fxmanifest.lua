fx_version 'cerulean'
game 'gta5'
author 'ChristianBDev & MrNewb'
description 'Parking meter script'
version '1.1.0'

client_scripts {
	'bridge/**/client.lua',
	'client/main.lua',
	'config.lua'
}
server_scripts {
	'bridge/**/server.lua',
	'server/main.lua',
	'config.lua'
}

shared_scripts {
	--'@qb-core/shared/locale.lua', -- Uncomment if using qb-core
	'@ox_lib/init.lua', -- comment out if not using ox_lib
	'config.lua'
}

lua54 'yes'
