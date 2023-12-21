local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function()
    QBCore = exports['qb-core']:GetCoreObject()
end)

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
					ClearPlayerWantedLevel(PlayerId())
					exports["Venice-Notification"]:Notify("Anda Masuk Zone", 5000, "check")
					--exports['mythic_notify']:SendAlert('inform', 'Anda Masuk Zone Tidur')
				end
			end
		end
		if lokasi.tempat then
			CurrentAction = nil
			antiCollision()
			DisableViolentActions()
			DrawTxt(0.670, 1.430, 1.0,1.0,0.45,"~y~ZONE TIDUR", 255,255,255,255)
			
			
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
    SetEntityCanBeDamaged(vehicle, false)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    DisablePlayerFiring(ped, true)
    SetPlayerCanDoDriveBy(ped, false)
    DisableControlAction(2, 37, true)
    DisableControlAction(0, 106, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 69, true)
    DisableControlAction(0, 70, true)
    DisableControlAction(0, 92, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 80, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 250, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 114, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 331, true)
    DisableControlAction(0, 68, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 264, true)
    if IsDisabledControlJustPressed(2, 37) then
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    end
    if IsDisabledControlJustPressed(0, 106) then 
        SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    end
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
			TriggerServerEvent('consumables:server:addHunger', 30000)
			TriggerServerEvent('consumables:server:addThirst', 30000)
		end
	end
end)