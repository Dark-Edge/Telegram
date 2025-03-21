FeatherMenu = exports['feather-menu'].initiate()
local BccUtils = {}
TriggerEvent('bcc:getUtils', function(bccutils)
    BccUtils = bccutils
end)
local Core = exports.vorp_core:GetCore()
local Playerstable = {}
local MailboxMenu, RegisterPage, MailActionPage, SendMessagePage, CheckMessagePage, SelectLocationPage
local selectedLocation = ''
local LocationETA = ''
local ETADisplay = nil 
local playermailboxId = nil
local isOpen = false
local news = {}
local animselected = 0

-- Function to open the mailbox menu
function OpenMailboxMenu(hasMailbox,model,name,source)
    SendMessagePage = nil
    CheckMessagePage = nil
	MailActionPage = nil
    if playermailboxId == nil then
        playermailboxId = "Not Registered"
    end
    if not MailboxMenu then
        MailboxMenu = nil
        MailboxMenu = FeatherMenu:RegisterMenu('feather:mailbox:menu', {
			top = "15%",
            left = "25%",
            ['720width'] = '900px',
			['1080width'] = '1000px',
			['2kwidth'] = '2000px',
			['4kwidth'] = '3000px',
            style = {
                ['background-image'] = 'url("nui://HLW_telegram/Mailtemplate.png")',
                ['background-size'] = 'cover',  
                ['background-repeat'] = 'no-repeat',
                    ['background-position'] = 'center',
                    ['background-color'] = 'rgba(55, 33, 14, 0.7)', -- A leather-like brown
                    ['border'] = '1px solid #654321', 
                    ['font-family'] = 'Times New Roman, serif', 
                    ['font-size'] = '38px',
                    ['color'] = '#ffffff', 
                    ['padding'] = '10px 20px',
                    ['margin-top'] = '5px',
                    ['cursor'] = 'pointer', 
                    ['box-shadow'] = '3px 3px #333333', 
                    ['text-transform'] = 'uppercase', 
            },
            contentslot = {
                style = {
                    ['max-height'] = '650px',  -- Fixed maximum height
                } -- Fixed maximum height
            },
            draggable = true,
        })
    end
    if not RegisterPage then
        RegisterPage = MailboxMenu:RegisterPage('register:page')
        RegisterPage:RegisterElement('header', {
            value = 'Enregistrement de boite postale',
            slot = "header",
            style = {
                ['font-family'] = 'Times New Roman, serif', 
                ['text-transform'] = 'uppercase', 
                ['color'] = 'rgb(0, 0, 0)',
            }
        })       
        RegisterPage:RegisterElement('button', {
            label = "S'enregistrer",
            style = {
    
            }
        }, function()
            TriggerServerEvent("Fists-GlideMail:registerMailbox")
            MailActionPage:RouteTo()
        end)    
    end
    if not MailActionPage then
        MailActionPage = MailboxMenu:RegisterPage('mailaction:page')
        MailActionPage:RegisterElement('header', {
            value = 'Boite postale',
            slot = "header",
            style = {
                ['font-family'] = 'Times New Roman, serif', 
                ['text-transform'] = 'uppercase', 
                ['color'] = 'rgb(0, 0, 0)',
            }
        })
        MailboxDisplay = MailActionPage:RegisterElement('textdisplay', {
            value = "N° de boite postale:" ..playermailboxId,
            style = {
                ['color'] = 'rgb(0, 0, 0)',
            }
        })
        MailActionPage:RegisterElement('button', {
            label = "Send Mail",
            style = {
    
            }
        }, function(data)
            SendMessagePage:RouteTo()
        end)
    end
    if not SendMessagePage then
        SendMessagePage = MailboxMenu:RegisterPage(`sendmail:page`)
        SendMessagePage:RegisterElement('header', {
            value = 'Envoyer une lettre',
            slot = "header",
            style = {
                ['font-family'] = 'Times New Roman, serif', 
                ['text-transform'] = 'uppercase', 
                ['color'] = 'rgb(0, 0, 0)',
            }
        })
        local recipientId = ''
        local mailMessage = ''
        local subjectTitle = ''
		--[[
        ETADisplay = SendMessagePage:RegisterElement('textdisplay', {
            value = "Current district is "..tostring(current_town),  
            style = {
                ['font-family'] = 'Times New Roman, serif', 
                ['text-transform'] = 'uppercase', 
                ['color'] = 'rgb(0, 0, 0)',
            }
        })   --]]     
        SendMessagePage:RegisterElement('input', {
            label = "A:",
            placeholder = "N° de boite du destinataire",
            persist = false,
            style = {
            }
        }, function(data)
            recipientId = data.value
            --print("To input: ", LocationETA)
        end)
        SendMessagePage:RegisterElement('input', {
            persist = false,
            label = "Sujet",
            placeholder = "Sujet du message ici...",
            style = {
            }
        }, function(data)
            subjectTitle = data.value
        end)
    SendMessagePage:RegisterElement('textarea', {
        label = 'Message',
        persist = false,
        placeholder = "Tapez votre message ici...",
        rows = "6",
        cols = "45",
        resize = true,
        style = {
            ['background-color'] = 'rgba(255, 255, 255, 0.6)',  
        }

    }, function(data)
        mailMessage = data.value
    end) 
	local anonymous = false -- prevent the value to persist as true if box not checked
	SendMessagePage:RegisterElement('checkbox', {
		label = "Anonyme",
		persist = false,
		start = false,
	}, function(data)
		-- This gets triggered whenever the sliders selected value changes
		anonymous = data.value
	end)	
    SendMessagePage:RegisterElement('button', {
        label = "Envoyer un message",
        style = {},
    }, function(data)
        --print("recipientId: ", recipientId, "subjectTitle: ", subjectTitle, "mailMessage: ", mailMessage, "selectedLocation: ", selectedLocation, "ETA Seconds", LocationETA)
		--print(anonymous) -- debug
        if Config.SendPigeon then
			TriggerServerEvent("Fists-GlideMail:sendMail", recipientId, subjectTitle, mailMessage, selectedLocation, LocationETA,model,source,Playerstable,anonymous,name)  -- Pass raw ETA seconds     
        end
        MailboxMenu:Close()
    end)
    end
    SendMessagePage:RegisterElement('button', {
        label = "Retour",
        style = {
            ['background-color'] = 'rgb(226, 0, 0)',
            ['color'] = 'rgb(226, 0, 0)',
        },
    }, function()
        MailActionPage:RouteTo()
    end)
	function CalculateDistanceBetweenCoords(coords1, coords2)
        return #(coords1 - coords2)  -- 
    end    
    function FormatTime(seconds)
        local minutes = math.floor(seconds / 60)
        local seconds = math.floor(seconds % 60)
        return string.format("%02d:%02d", minutes, seconds)
    end   
    -- Location Stuff
	local x,y,z =  table.unpack(GetEntityCoords(PlayerPedId()))	
	-- Find ZoneName of type "District" at current coords. Returns false if nothing of this type was found:
	local ZoneTypeId = 1
	local current_town = Citizen.InvokeNative(0x43AD8FC02B429D33 ,x,y,z,ZoneTypeId)
	print(current_town) -- debug
	if current_town then
		for k,TOWN in pairs (Locations) do
			if k == "TOWN" then
				for i,Location in pairs (TOWN) do
					if (tostring(Location.Hash) == tostring(current_town)) then
						current_town = Location.Label
						print("Current town is "..tostring(current_town))
					end
				end
			end
		end
	else
	current_town = Citizen.InvokeNative(0x43AD8FC02B429D33 ,x,y,z,10)
	print(current_town) -- debug
		for k,DISTRICTS in pairs (Locations) do
			if k == "DISCTRICTS" then
				for i,Location in pairs (DISTRICTS) do
					if (tostring(Location.Hash) == tostring(current_town)) then
						current_town = Location.Label
						print("Current district is "..tostring(current_town))
					end
				end
			end
		end
	end
    selectedLocation = tostring(current_town)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = CalculateDistanceBetweenCoords(playerCoords,playerCoords)
    local etaSeconds = distance * Config.TimePerMile
    LocationETA = etaSeconds  -- Store raw ETA in seconds
    local formattedETA = FormatTime(etaSeconds)  -- Format for display
    --[[
	if ETADisplay ~= nil then
        ETADisplay:update({
            value = "ETA: " .. formattedETA
        })
    end --]]
    if hasMailbox then
        MailboxMenu:Open({ startupPage = MailActionPage })
    else
        MailboxMenu:Open({ startupPage = RegisterPage })
    end
end

RegisterNetEvent("Fists-GlideMail:mailboxStatus")
AddEventHandler("Fists-GlideMail:mailboxStatus", function(hasMailbox, mailboxId,model,name,source)
    playermailboxId = mailboxId
    OpenMailboxMenu(hasMailbox,model,name,source)
end)

RegisterNetEvent("Fists-GlideMail:registerResult")
AddEventHandler("Fists-GlideMail:registerResult", function(success, message)
    if success then
		--print('test')
        RegisterPage:RegisterElement('button', {
            label = "Mail Actions"
        }, function()
            MailActionPage:RouteTo()
        end)
    else
    end
end)

RegisterNetEvent("Fists-GlideMail:updateMailboxId")
AddEventHandler("Fists-GlideMail:updateMailboxId", function(newMailboxId)
    playermailboxId = newMailboxId -- Update the playermailboxId variable
    if MailboxDisplay ~= nil then
        MailboxDisplay:update({
            value = "Votre boite postale est la N°: " .. playermailboxId
        })
    end
end)

function GetMailLocationCoords(locationName)
    for _, loc in ipairs(Config.MailboxLocations) do
        if loc.name == locationName then
            return loc.coords
        end
    end
    return nil  
end

function IsPlayerAtLocation(playerCoords, locationCoords)
    return Vdist(playerCoords, locationCoords.x, locationCoords.y, locationCoords.z) < 10  
end

RegisterNetEvent('SendPigeon')
AddEventHandler('SendPigeon', function(initmodel)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnCoords = vector3(playerCoords.x + 0.0, playerCoords.y + 0.0, playerCoords.z + 0.0)
    local model = GetHashKey(initmodel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    local pigeon = CreatePed(model, spawnCoords.x, spawnCoords.y+2.0, spawnCoords.z+2.0, 0.0, true, false, true, true)
	SetRandomOutfitVariation(pigeon,false)
	repeat Wait(5000) until TaskFlyToCoord(pigeon,0.1,playerCoords.x+30,playerCoords.y+30,playerCoords.z+30,true,true)
	FadeAndDestroyPed(pigeon)
    SetModelAsNoLongerNeeded(model)
end)

RegisterNetEvent('ReceivePigeon')
AddEventHandler('ReceivePigeon', function(initmodel,PlayerName,recipientId)
	local player = PlayerId()
	local LocalPlayerName = GetPlayerName(player)
	local IsPlayerConnected = true
	TriggerEvent("vorp:TipRight", "You Received a message", 5000)
	--print(initmodel)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local spawnCoords = vector3(playerCoords.x + 30.0, playerCoords.y + 30.0, playerCoords.z + 30.0)
	local model = GetHashKey(initmodel)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
	local pigeon = CreatePed(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false, true, true)
	SetRandomOutfitVariation(pigeon,false)
	TaskFlyToCoord(pigeon,0.1,playerCoords.x,playerCoords.y,playerCoords.z,true,true)
	Wait(15000)
	FadeAndDestroyPed(pigeon)
	SetModelAsNoLongerNeeded(model)	
	TriggerServerEvent('AddItemMailToPlayer',source)
end)


RegisterNetEvent('CRSC')
AddEventHandler('CRSC', function()
	local player = PlayerId()
	local _source = GetPlayerServerId(player)
	local LocalPlayerName = GetPlayerName(player)
	local PlayerTable = {
		source = _source,
		steamname = LocalPlayerName
	}
	print(json.encode(PlayerTable))
	TriggerServerEvent('CR2S',_source,PlayerTable)
end)        
    
Citizen.CreateThread(function()
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup() 
    local mailboxPrompt = nil
    function registerMailboxPrompt()
        if mailboxPrompt then
            mailboxPrompt:DeletePrompt() 
        end
        mailboxPrompt = PromptGroup:RegisterPrompt("Open Mailbox", 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})
    end
    while true do
        Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local player = PlayerId()
        local playerCoords = GetEntityCoords(playerPed)
		local LocalPlayerName = GetPlayerName(player)
        local nearMailbox = false
        for _, location in pairs(Config.MailboxLocations) do
            if Vdist(playerCoords, location.coords.x, location.coords.y, location.coords.z) < 2 then
                nearMailbox = true
                break
            end
        end
        if nearMailbox then
            if not mailboxPrompt then
                registerMailboxPrompt()
            end
            PromptGroup:ShowGroup("Near Mailbox")

            if mailboxPrompt:HasCompleted() then
                --TriggerServerEvent("Fists-GlideMail:checkMailbox")
				--print(LocalPlayerName) -- debug
				TriggerServerEvent("Mail:OpenInventory",LocalPlayerName)
                registerMailboxPrompt() 
            end
        else
            if mailboxPrompt then
                mailboxPrompt:DeletePrompt()
                mailboxPrompt = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, location in ipairs(Config.MailboxLocations) do
        local x, y, z = table.unpack(location.coords) 
        local blip = BccUtils.Blip:SetBlip('Telegram', 'blip_post_office_rec', 0.2, x, y, z)
    end
end)

function LoadModel(model, modelName)
    if not IsModelValid(model) then
        return print('Invalid model:', modelName)
    end
    RequestModel(model, false)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

RegisterNetEvent('PlayAnim')
AddEventHandler('PlayAnim', function(mail,anim)
	animselected = anim
	local ped = PlayerPedId()
	if animselected == 0 then
		local animDict = "mech_inspection@picture_frame@base"
		local animName = "hold"
		Anim(ped, animDict, animName, -1, 30)
		OpenUI(mail)
	elseif animselected == 1 then	
		local animDict = "mech_inventory@document@world_player_inspect_letter@50cm@paper_w15-1_h24_foldvertical"
		local animName = "base"
		Anim(ped, animDict, animName, -1, 30)
		OpenUI(mail)
	elseif animselected == 2 then	
		local animDict = "mech_inspection@letter@base"
		local animName = "hold_inspect_enter"
		Anim(ped, animDict, animName, -1, 30)
		OpenUI(mail)
	elseif animselected == 3 then
		local animDict = "mech_inspection@letter@satchel"
		local animName = "enter"
		Anim(ped, animDict, animName, -1, 30)
		OpenUI(mail)
	end
end)

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
		DetachEntity(prop,false,true)
		ClearPedTasks(ped)
		DeleteObject(prop)
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		local player = PlayerPedId()
		local coords = GetEntityCoords(player) 
		local props = CreateObject(GetHashKey("p_cs_letterfolded02x"), coords.x, coords.y, coords.z, 1, 0, 1)
		prop = props
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout > 0) do
            timeout = timeout - 1
            if timeout == 0 then
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
	SetEntityAsMissionEntity(props,true,true)
	if animselected == 0 or animselected == 1 then
		Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop,player,GetEntityBoneIndexByName(player,"SKEL_L_Finger10"), 0.04, -0.13, 0.01, 0.0, -0.3, -80.0, true, true, false, true, 1, true)
	elseif animselected == 2 then
		Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop,player,GetEntityBoneIndexByName(player,"SKEL_L_Finger10"), 0.01, -0.12, 0.02, -10.0, -10.0, -80.0, true, true, false, true, 1, true)
	elseif animselected == 3 then
		Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop,player,GetEntityBoneIndexByName(player,"SKEL_L_Finger10"), 0.02, -0.12, 0.02, 80.0, 60.0, -110.0, true, true, false, true, 1, true)
	end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end

function StopAnim(dict, body)
    Citizen.CreateThread(function()
        StopAnimTask(PlayerPedId(), dict, body, 1.0)
    end)
end

function OpenUI(mail)
    local playerPed = PlayerPedId()
    isOpen = true
	SetNuiFocus(true,false)
	SetNuiFocusKeepInput(true)
    SendNUIMessage({
    type = "show",
    value = true,
    subject = mail.subject,
	message = mail.message,
	sender 	= mail.sender,
	coords	= mail.coords,
	date	= mail.date,
    })
end

RegisterNetEvent('OpenMailTicket')
AddEventHandler('OpenMailTicket', function(MailID)
	TriggerEvent("CheckReceiverSource",-1)
	local playerPed = PlayerPedId()
    isOpen = true
	SetNuiFocus(true,false)
	SetNuiFocusKeepInput(true)
	--print(json.encode(MailID))
    SendNUIMessage({
    type = "show2",
    value = true,
    id = MailID,
    })
end)

function CloseUI()
    local playerPed = PlayerPedId()
    isOpen = false
	SetNuiFocus(false,false)
    active = false
    FreezeEntityPosition(PlayerPedId(), false)
	RangerJournal()
end

function RangerJournal()
    local ped = PlayerPedId()
	local animDict = "mech_inspection@two_fold_map@satchel"
	local animName = "exit_satchel"
	Anim(ped, animDict, animName,-1,30)
	Wait(2000)
	ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
    DetachEntity(prop,false,true)
    ClearPedTasks(ped)
    DeleteObject(prop)
end

RegisterNUICallback('close', CloseUI)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		DetachEntity(prop,false,true)
		ClearPedTasks(ped)
		DeleteObject(prop)	
        FreezeEntityPosition(PlayerPedId(), false)
		CloseUI()
    end
end)