Config = {}

Config.RegistrationFee = 2 -- Cost to register
Config.invLimit = 200 -- inventory slots
Config.SendMessageFee = 0 --Cost to send messages
Config.TimePerMile = 0.1 -- Time in seconds per mile
Config.SendPigeon = true -- If you want the Pigeon or not

Config.MailboxLocations = {
    { name = "Annesburg", coords = vector3(2939.47, 1288.51, 44.65) }, 
    { name = "Armadillo", coords = vector3(-3733.91, -2597.8, -12.93) },
    { name = "Blackwater", coords = vector3(-874.91, -1328.74, 43.96) },
    { name = "Rhodes", coords = vector3(1225.58, -1293.97, 76.91) },
    { name = "Saint Denis", coords = vector3(2731.46, -1402.37, 46.18) },  
    { name = "Strawberry", coords = vector3(-1765.2, -384.26, 157.74) },
    { name = "Valentine", coords = vector3(-180.12, 627.28, 114.09) }, 
    -- { name = "Another Location", coords = vector3(x, y, z) },
}

Config.UsableItems = {
	{ name = "Hibou", model = "A_C_Owl_01"},
	{ name = "Pigeon", model = "A_C_Pigeon"},
	-- { name = "Another bird to send", model = "exemple_model" },
}

