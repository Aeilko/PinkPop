Db = require 'db'
Plugin = require 'plugin'
Event = require 'event'

exports.onInstall = !->
	Event.create
		unit: 'msg'
		text: "PinkPop plugin installed!"

exports.client_wantToSee = (artiest, cb) !->
	Db.shared.modify 'wantToSee', artiest, Plugin.userId(), (v) -> ((v||0)+1)%2