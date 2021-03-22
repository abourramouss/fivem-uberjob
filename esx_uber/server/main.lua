ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



businessLocations = { --Business locations where the uber driver will be recolecting the packages, any coordinate must be a float!!
[1] = {["x"] = -53.61, ["y"] = -1757.00, ["z"] = 29.0, ["title"]="24/7 Uber Delivery"}
}

deliveryLocations = {  --- Door cords to leave the packages
  [1] = {["x"] = 8.91, ["y"] = -242.82, ["z"] = 51.86}
}



RegisterServerEvent('esx_uber:startWork')
AddEventHandler('esx_uber:startWork', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local jobInfo = xPlayer.job.name
    if _source~= nil then
        if jobInfo ~= nil then
            TriggerClientEvent('showNotify', source,xPlayer.name .. ": ~b~You're now working as a Uber driver")
            TriggerClientEvent('esx_uber:startDestination',_source)
        end
    end
end)


RegisterServerEvent('esx_uber:pay')
AddEventHandler('esx_uber:pay', function(amount)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addMoney(tonumber(amount))

end)