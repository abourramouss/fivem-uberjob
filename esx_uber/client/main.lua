
local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}
hasJobUber = false
ESX = nil
deliveryID = 0


Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(200)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end
end)

RegisterNetEvent('showNotify')

AddEventHandler('showNotify', function(notify)
    ShowAboveRadarMessage(notify)
end)

function ShowAboveRadarMessage(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function Draw3DText2(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    -- DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
end

function dBetweenPoints(x1,x2,y1,y2,z1,z2)
    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2
    return math.sqrt ( dx * dx + dy * dy + dz * dz )

end






function createBlip(selectedDest,arr)
    uberdeliveryblip = AddBlipForCoord(arr[selectedDest]["x"], arr[selectedDest]["y"],
                           arr[selectedDest]["z"])
    SetBlipSprite(uberdeliveryblip, 1)
    SetBlipColour(uberdeliveryblip, 16742399)
    SetBlipScale(uberdeliveryblip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(arr[selectedDest]["title"])
    EndTextCommandSetBlipName(uberdeliveryblip)
    SetNewWaypoint(arr[selectedDest]["x"], arr[selectedDest]["y"])

    return uberdeliveryblip
end

function genericFunc(type, selectedDest, loc)
    local PackageDeliveryObject
    if type == "PICKUP" then
        PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"),loc[selectedDest]["x"],
        loc[selectedDest]["y"], loc[selectedDest]["z"], true)
        PlaceObjectOnGroundProperly(PackageDeliveryObject)
    end
    local takenpackage
    local hasActionStarted = true
    while hasActionStarted do
        Citizen.Wait(0)
        local player = source
        local ped = GetPlayerPed(player)
        
        if GetDistanceBetweenCoords(GetEntityCoords(ped),loc[selectedDest]["x"],
        loc[selectedDest]["y"], loc[selectedDest]["z"], true) < 20.0 then
            Draw3DText2(loc[selectedDest]["x"], loc[selectedDest]["y"],
            loc[selectedDest]["z"] + 0.3, tostring("~w~~g~[E]~w~" .. type .. " Package"))


            if IsControlJustPressed(1, Keys["E"]) then
                TaskStartScenarioInPlace(PlayerPedId(-1), "PROP_HUMAN_BUM_BIN", 0, true)

                if type == "PICKUP" then
                    exports["t0sic_loadingbar"]:StartDelayedFunction(type, 5000, function(type)
                        takenpackage = true
                        hasActionStarted = false
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(PlayerPedId(-1))
                        DeleteObject(PackageDeliveryObject)

                    end)

                elseif type == "DELIVER" then
                    exports["t0sic_loadingbar"]:StartDelayedFunction(type, 5000, function(type)
                        takenpackage = true
                        hasActionStarted = false
                        local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"),
                        loc[selectedDest]["x"],
                        loc[selectedDest]["y"],
                        loc[selectedDest]["z"], true)
                        PlaceObjectOnGroundProperly(PackageDeliveryObject)
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(PlayerPedId(-1))
                        DeleteObject(PackageDeliveryObject)
                    end)
                end
                RemoveBlip(blip)

            end
        end
    end
    return takenpackage
end

Citizen.CreateThread(function()
    RegisterNetEvent('esx_uber:startDestination')
    AddEventHandler('esx_uber:startDestination', function()
        if not hasJobUber then
          hasJobUber = true
          local dist = 0
          local deliverDest
          local selectedDest
          while dist < Config.distance 
            do
            math.randomseed(GetGameTimer())
            math.random(); math.random(); math.random();
            deliverDest = math.random(1,tablelength(Config.deliveryLocations))
            selectedDest =  math.random(1,tablelength(Config.businessLocations))
            dist = dBetweenPoints(Config.deliveryLocations[deliverDest]["x"],Config.businessLocations[selectedDest]["x"], Config.deliveryLocations[deliverDest]["y"],Config.businessLocations[selectedDest]["y"], Config.deliveryLocations[deliverDest]["z"],Config.businessLocations[selectedDest]["z"])
            
            print(math.floor(tonumber(dist)) .. "<" .. tonumber(Config.distance)   )
            Citizen.Wait(1000)
        end
          takePackageBlip = createBlip(selectedDest,Config.businessLocations)
          local isTaken, isDelivered = false
          if isTaken == false then
              isTaken = genericFunc("PICKUP", selectedDest,Config.businessLocations)
          end
          if isTaken then
            deliverPackageBlip = createBlip(deliverDest,Config.deliveryLocations)  
            isDelivered = genericFunc("DELIVER", deliverDest,Config.deliveryLocations)
              isTaken = false
          end

          if isDelivered then
              deliveryID = deliveryID + 1;
              TriggerServerEvent('esx_uber:delivery_complete', source, deliveryID)
              isDelivered = false
              isTaken = false
              hasJobUber = false
          end
        end
    end)
end)

RegisterCommand("uberJob", function()
    TriggerServerEvent('esx_joblisting:setJob', 'uber')
    TriggerServerEvent('esx_uber:startWork')
end, false)

