local Translations = {
	progress = {
		['grabcash'] = 'Grabbing Extra Change!',
	},
	notify = {
		['robbed'] = 'You have stolen $',
		['failed'] = 'Failed to rob parking meter',
		['pickup'] = 'Failed to pickup pocket change',
		['cooldown'] = 'You must wait you grinder!',
	},
	info = {
		['rob'] = 'Rob Parking Meter',
	},
}

Lang = Lang or Locale:new({
	phrases = Translations,
	warnOnMissing = true
})
