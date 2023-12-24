print("^7^2QB-AFKZONE ^7v^41^1.^41^1.^40 ^7- ^2 Script by MatFirdaus^7")

local QBCore = exports['qb-core']:GetCoreObject()

Config = {}


local besarradius = 60
local blips = {
	{title="AFK Zone Tasik", colour=2, id=269, x = 1084.19, y = -694.17, z = 58.01, radius = besarradius+0.0}
}

local zone = {
	["tasik"] = {x = 1084.19, y = -694.17, z = 58.01, radius = besarradius}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.55)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)

	for k,v in pairs(blips) do
		zoneblip = AddBlipForRadius(v.x,v.y,v.z,v.radius)
		SetBlipColour(zoneblip,2)
		SetBlipAlpha(zoneblip,75)
		end
	end
end)

local lokasi = {tempat = false,x=nil,y=nil,z=nil,radius=nil}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local orang = GetPlayerPed(-1)
		local x,y,z = table.unpack(GetEntityCoords(orang, true))
		
		if(lokasi.tempat == false) then
			for i,v in pairs(zone) do
				if(Vdist(x,y,z,v.x,v.y,v.z) <= v.radius) then
					lokasi.tempat = true
					lokasi.x,lokasi.y,lokasi.z,lokasi.radius = v.x,v.y,v.z,v.radius
					exports["Venice-Notification"]:Notify("Anda Masuk Zone", 5000, "check")
					--exports['mythic_notify']:SendAlert('inform', 'Anda Masuk Zone Tidur')
				end
			end
		end
		if lokasi.tempat then
			CurrentAction = nil
			antiCollision()
			DisableViolentActions()
			DrawTxt(1.150, 1.460, 1.0,1.0,0.50,"~r~AFK~r~ ~r~ZONE~r~", 255,255,255,255)
			
			
			if(Vdist(x,y,z,lokasi.x,lokasi.y,lokasi.z) > besarradius) then
				lokasi.tempat = false
				lokasi.x,lokasi.y,lokasi.z,lokasi.radius = nil,nil,nil,nil
				exports["Venice-Notification"]:Notify("Anda Keluar Zone Tidur", 5000, "info")
				--exports['mythic_notify']:SendAlert('inform', 'Anda keluar Zone Tidur')
			end
		end
	end
end)

function DisableViolentActions()
	NetworkSetFriendlyFireOption(false)
    DisablePlayerFiring(ped, true)
	DisablePlayerFiring(player,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
	DisablePlayerFiring(player,true)  -- Disables firing all together
	DisableControlAction(0, 140, true) -- R
	DisableControlAction(0, 25, true) -- RIGHT MOUSE BUTTON Aim
end

function antiCollision()
	local playerPed = PlayerPedId()
	for _, i in ipairs(GetActivePlayers()) do
		local otherPlayerPed = PlayerPedId(i)
		SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
		SetEntityNoCollisionEntity(otherPlayerPed, playerPed, true)
    end
end

function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
    while true do
		Wait(120000)
		if lokasi.tempat then
			TriggerServerEvent('consumables:server:addHunger', 10000)
			TriggerServerEvent('consumables:server:addThirst', 10000)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		Wait(0)
		if lokasi.tempat then
			invisible = true
			SetEntityAlpha(PlayerPedId(), 200, false)
		end
	end
end)
