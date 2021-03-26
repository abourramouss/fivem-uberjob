ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

deliverHistory = {}

businessLocations = { --Business locations where the uber driver will be recolecting the packages, any coordinate must be a float!!
[1] = {["x"] = -53.61, ["y"] = -1757.00, ["z"] = 29.0, ["title"]="24/7 Uber Delivery"}
}

deliveryLocations = {  --- Door cords to leave the packages
  [1] = {["x"] = 8.91, ["y"] = -242.82, ["z"] = 51.86}
}

RegisterNetEvent('esx_uber:delivery_complete')
AddEventHandler('esx_uber:delivery_complete', function(user,delivery)
        
    if source ~= nil then 
        if deliverHistory[source] ~= nil then
            deliverHistory[source] = deliverHistory[source] + 1
        else
            deliverHistory[source] = 1
        end
        
    end
   
end)
--Payment
Citizen.CreateThread(function()
    while true do
        for k,v in pairs(deliverHistory) do
            if deliverHistory[k] ~= nil then
                print(k.. " " .. deliverHistory[k] )
                local xPlayer = ESX.GetPlayerFromId(k)
                if xPlayer ~= nil then
                    local totalPay= tonumber(deliverHistory[k]*1000)
                    xPlayer.addMoney(totalPay)
                    TriggerClientEvent('showNotify', k,xPlayer.name .. ": ~b~Your deliveries just got paid! \nA total of: " .. totalPay .. " were added to your account" )
                    deliverHistory[k] = nil
                    xPlayer = nil
                end
            end
        end
    Citizen.Wait(1000)
    end
end)



RegisterServerEvent('esx_uber:startWork')
AddEventHandler('esx_uber:startWork', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local jobInfo = xPlayer.job.name
    if _source~= nil then
        if jobInfo ~= nil then
            TriggerClientEvent('showNotify', source,xPlayer.name .. ": ~b~You're now working as a Uber driver")
            TriggerClientEvent('esx_uber:startDestination',_source,1)
        end
    end
end)


