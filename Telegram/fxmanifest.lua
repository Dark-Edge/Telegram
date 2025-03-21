fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game "rdr3"

description 'telegram system Rescripted by Darky_13 original by Fistsofury'
client_scripts {
	'client/client.lua',
	'client/locations.lua',
}

shared_scripts {
    'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

files {
    'Mailtemplate.png',
    'selection_box_bg.png',
    'fonts/FrederickatheGreat-Regular.ttf',
	'html/client.js',
	'html/chinese rocks rg.ttf',
	'html/chineser-webfont.woff',
	'html/chineser-webfont.woff2',
	'html/index.html',
	'html/stylesheet.css',
	'html/turnjs4/extras/jGestures-license.txt',
	'html/turnjs4/extras/jgestures.min.js',
	'html/turnjs4/extras/jquery-ui-1.8.20.custom.min.js',
	'html/turnjs4/extras/jquery.min.1.7.js',
	'html/turnjs4/extras/jquery.mousewheel.min.js',
	'html/turnjs4/extras/modernizr.2.5.3.min.js',
	'html/turnjs4/lib/compress.sh',
	'html/turnjs4/lib/hash.js',
	'html/turnjs4/lib/scissor.js',
	'html/turnjs4/lib/scissor.min.js',
	'html/turnjs4/lib/turn.html4.js',
	'html/turnjs4/lib/turn.html4.min.js',
	'html/turnjs4/lib/turn.js',
	'html/turnjs4/lib/turn.min.js',
	'html/turnjs4/lib/zoom.js',
	'html/turnjs4/lib/zoom.min.js',
}

ui_page 'html/index.html'

lua54 'yes'