ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('by_mis1:obj')
AddEventHandler('by_mis1:obj', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

    xPlayer.addInventoryItem('suministros', 1)
    Citizen.Wait(1500)

end)

RegisterServerEvent('by_mis1:sellSuministros')
AddEventHandler('by_mis1:sellSuministros', function(itemName, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local reward = math.floor(Config.SuministrosPrice * Config.MaxSuministrosSell)

	xPlayer.removeInventoryItem('suministros', Config.MaxSuministrosSell)
	xPlayer.addMoney(reward)
end)