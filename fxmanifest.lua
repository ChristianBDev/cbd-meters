fx_version 'cerulean'
game 'gta5'
author 'ChristianBDev & MrNewb'
description 'Parking meter script'
version '1.1.2'

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
	'@ox_lib/init.lua', -- comment out if not using ox_lib
	'config.lua'
}

lua54 'yes'
