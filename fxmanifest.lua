fx_version 'cerulean'
game 'gta5'
author 'ChristianBDev Scripts'
description 'Parking Meter Robbery Script'
version '1.2.0'

client_scripts {
	'client/main.lua',
	'config.lua'
}
server_scripts {
	'server/main.lua',
	'config.lua'
}

shared_scripts {
	'@ox_lib/init.lua', -- comment out if not using ox_lib
    'config.lua'
}

files {
	'locales/*.json', -- Add your own language files here if needed
}

dependencies {
	'ox_lib', -- comment out if not using ox_lib | https://github.com/CommunityOx/ox_lib
	'community_bridge', -- Community_Bridge | https://github.com/The-Order-Of-The-Sacred-Framework/community_bridge
}

lua54 'yes'
