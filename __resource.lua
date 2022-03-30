resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'QBcore NoCarJack'

version '1.0'

server_scripts {
	'server/nocarjack_sv.lua'
}

client_scripts {
	'client/nocarjack_cl.lua',
	'cfg/nocarjack.lua'
}
