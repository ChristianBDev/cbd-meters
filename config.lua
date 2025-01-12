Config = Config or {}

Config.DevDebug 	= false -- Set to true to enable onResourceStart and onResourceStop events

Config.Target 	 	= 'qb' -- qb, ox
Config.NotifyType	= 'qb' -- qb, ox, esx, custom
Config.Progress   	= 'qb' -- qb, ox, esx
Config.SkillCheck 	= 'qb' -- qb, ox

Config.Money      	= math.random(100, 500)  -- Gives random amount within range
Config.AlertChance 	= 25

Config.LootTime 	= 10
Config.Cooldown 	= 60

Config.meterModels 	= {
	"prop_parknmeter_01",
	"prop_parknmeter_02"
}