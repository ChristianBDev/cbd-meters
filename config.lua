Config = Config or {}

Config.DevDebug 	= true -- Set to true to enable onResourceStart and onResourceStop events

Config.Target 	 	= 'ox' -- qb, ox
Config.NotifyType	= 'ox' -- qb, ox, esx, custom
Config.Progress   	= 'ox' -- qb, ox, esx
Config.SkillCheck 	= 'ox'  -- qb, ox, custom

Config.Money      	= math.random(100, 500)  -- Gives random amount within range
Config.AlertChance 	= 25

Config.LootTime 	= 10
Config.Cooldown 	= 60

Config.meterModels 	= {
	"prop_parknmeter_01",
	"prop_parknmeter_02"
}