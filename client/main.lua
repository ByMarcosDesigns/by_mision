ESX = nil
MisionStart = false
Collected = false
Entregado = false

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

--Apartado para crear el ped
Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_blackops_01")

    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", "s_m_y_blackops_01", -1095.587, -817.5297, 18.03516, 301.220, false, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

--Apartado Donde empezamos la mision 
Citizen.CreateThread(function()
    while true do
        local wait = 1300

        local lspd = vector3(-1095.587, -817.5297, 18.03516)
        local pos = GetEntityCoords(ped)
        local Mision = Config.Point

        if MisionStart == false then
            if Vdist2(GetEntityCoords(PlayerPedId(), false), lspd) < 2.5 then
                ByNotify(pos.x, pos.y, pos.z + 0.99, "Presiona ~y~E ~w~para pedir una mision a Manuel")
		wait = 0
                if IsControlJustPressed(1,51) then
                    --print("Prueba")
                    startMission()
                    carSpawn()
                    MisionStart = true
                    Collected = false
                end
            end
	    Citizen.Wait(wait)
        end
    end
end)

--Donde se cancela la mision y se borra el vehiculo
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)

        local coords = Config.Cancel
        local pos = vector3(-1111.582, -801.5077, 16.77148)
        local marker = vector3(-1111.582, -801.5077, 16.77148)

        if MisionStart == true then
            DrawMarker(1,coords.point.x,coords.point.y, coords.point.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.5, 5.5, 0.5, 255, 41, 41, 100, false, true, 2, false, false, false, false)

            if Vdist2(GetEntityCoords(PlayerPedId(), false), marker) < 5.5 then
                ByNotify(pos.x, pos.y, pos.z + 0.99, "Pressiona ~y~E ~w~para cancelar las misiones")

                if IsControlJustPressed(1,51) then
                    print("Estoy cancelando la mision")
                    finishGo()
                    eliminarVeh()

                    ESX.ShowNotification("Para no hacer nada no me pidas trabajo hombre!!!")

                    Citizen.Wait(19000)
                    MisionStart = false

                    Citizen.Wait(19000)
                end
            end
        end
    end
end)

--Recoleccion de suministros
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local coords = Config.Farmeo
        local marker = vector3(-2291.248, 365.9736, 174.5927)
        local posi = vector3(-2291.248, 365.9736, 174.5927)
        local xPlayer = ESX.GetPlayerFromId 

        if MisionStart == true and Collected == false then
            DrawMarker(1,coords.pos.x,coords.pos.y,coords.pos.z - 1.0 , 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.5, 5.5, 0.5, 255, 41, 41, 100, false, true, 2, false, false, false, false)

            if Vdist2(GetEntityCoords(PlayerPedId(), false), marker) < 5.5 then
                ByNotify(posi.x, posi.y, posi.z + 0.77, "Pressiona ~y~E ~w~para recolectar suministros")

                if IsControlJustPressed(1,51) then

                    TriggerServerEvent('by_mis1:obj')

                    Citizen.Wait(10000)

                    ESX.ShowNotification("Vuelve a base y danos los suministros, a cambio te daremos una recompensa")

                    startSecond()
                    Collected = true
                end
            end

        end
    end
end)

--Donde se entregan los suministros y se deja el camion
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)

        local coords = Config.Finish
        local pos = vector3(-1137.613, -851.5253, 13.76123)
        local marker = vector3(-1137.613, -851.5253, 13.76123)

        if MisionStart == true and Collected == true and Entregado == false then
            DrawMarker(1,coords.point.x,coords.point.y, coords.point.z - 0.99, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.5, 5.5, 0.5, 255, 41, 41, 100, false, true, 2, false, false, false, false)

            if Vdist2(GetEntityCoords(PlayerPedId(), false), marker) < 5.5 then
                ByNotify(pos.x, pos.y, pos.z + 0.99, "Pressiona ~y~E ~w~para dejar el camion")

                if IsControlJustPressed(1,51) then
                    finishGo2()
                    if IsThisModelACar(0xC1632BEB) then
                        eliminarVeh()
                        ESX.ShowNotification("Dirigete al militar que te encargo la mision para que te de una recompensa por los suministros")
                        Entregado = true
                    else 
                        ESX.ShowNotification("Este no es el vehiculo que te hemos dado!!!!")
                        Entregado = false
                    end

                end
            end
        end
    end
end)

-- Vender Suministros
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        local lspd = vector3(-1095.587, -817.5297, 18.03516)
        local pos = GetEntityCoords(ped)
        local Mision = Config.Point

        if MisionStart == true and Collected == true and Entregado == true then
            if Vdist2(GetEntityCoords(PlayerPedId(), false), lspd) < 2.5 then
                ByNotify(pos.x, pos.y, pos.z + 0.99, "Presiona ~y~E ~w~para vender los suministros")

                Citizen.Wait(1)
                if IsControlJustPressed(1,51) then
                    print("Funciono puto")
                    TriggerServerEvent('by_mis1:sellSuministros')
                    Citizen.Wait(19000)
                    MisionStart = false
                    Citizen.Wait(19000)
                end
            end
        end
    end
end)

--Funcion para marcar el primer blip en el mapa
function startMission()
    local point = Config.Point
    blip = AddBlipForCoord(point.Pos.x,  point.Pos.y,  point.Pos.z)

    print("Estoy funcionando")


	SetBlipRoute(blip, true)
    AddTextComponentString('Mision - 1')
	BeginTextCommandSetBlipName("STRING")
	EndTextCommandSetBlipName(blip)

	
    ESX.ShowNotification('Manuel - Porfavor trae suministros escondidos en la siguiente ubicacion')
end

function startSecond()
    finishGo()

    local point = Config.secPoint
    blip2 = AddBlipForCoord(point.Pos.x,  point.Pos.y,  point.Pos.z)

    SetBlipRoute(blip2, true)
    AddTextComponentString('Mision - 1')
	BeginTextCommandSetBlipName("STRING")
	EndTextCommandSetBlipName(blip2)
end

-- Funcion para eliminar el primer blip 
function finishGo()
    RemoveBlip(blip)
end

function finishGo2()
    RemoveBlip(blip2)
end

--Funcion para hacer textos 3d en un mundo 2d
function ByNotify(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local factor = #text / 370
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    DrawRect(_x,_y + 0.0125, 0.060 + factor, 0.035, 0, 0, 0, 190)
end

-- Funcion para eliminar vehiculos
function eliminarVeh()
    local player = PlayerPedId()

    local vehicle = GetVehiclePedIsIn(player, true)

    ESX.Game.DeleteVehicle(vehicle)

end

--Funcion para spawnear vehiculos
function carSpawn()
    local player = PlayerPedId()

    ESX.Game.SpawnVehicle("mule2", Config.SpawnVehicle.Pos, 270, function(vehicle)
        TaskWarpPedIntoVehicle(player, vehicle, -1)
    end)
end
