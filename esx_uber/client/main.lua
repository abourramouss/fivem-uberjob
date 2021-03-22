local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

ESX = nil
payment = 1000

  businessLocations = { --Business locations where the uber driver will be recolecting the packages, any coordinate must be a float!!
  [1] = {["x"] = -53.61, ["y"] = -1757.00, ["z"] = 29.0, ["title"]="24/7 Uber Delivery"}
  }

 deliveryLocations = {  --- Door cords to leave the packages
    [1] = {["x"] = -53.61, ["y"] = -1757.00, ["z"] = 29.0, ["title"]="24/7 Uber Delivery"}
}

  Citizen.CreateThread(function()
      while ESX == nil do
          Citizen.Wait(200)
          TriggerEvent('esx:getSharedObject', function (obj) ESX = obj end)
      end
  end)

RegisterNetEvent('showNotify')

AddEventHandler('showNotify', function(notify)
	ShowAboveRadarMessage(notify)
end)

function ShowAboveRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
  DrawNotification(0,1)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Draw3DText2(x,y,z,text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  SetTextScale(0.35,0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  --DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 100)
end





RegisterNetEvent('esx_uber:startDestination')
AddEventHandler('esx_uber:startDestination', function ()
  --info about the table size for debugin
  local arrSize = tablelength(businessLocations) 
  local selectedDest = math.random(1,arrSize)   
  --Debugging
  uberdeliveryblip = AddBlipForCoord(businessLocations[selectedDest]["x"],  businessLocations[selectedDest]["y"],  businessLocations[selectedDest]["z"])
  SetBlipSprite(uberdeliveryblip,1)
  SetBlipColour(uberdeliveryblip,16742399)
  SetBlipScale(uberdeliveryblip,1)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(businessLocations[selectedDest]["title"])
  EndTextCommandSetBlipName(uberdeliveryblip)
  SetNewWaypoint(businessLocations[selectedDest]["x"],  businessLocations[selectedDest]["y"])
        
  --Do dis 2 times: implement it on a function

  --Pickup
        local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), businessLocations[selectedDest]["x"],  businessLocations[selectedDest]["y"],businessLocations[selectedDest]["z"], true)
        PlaceObjectOnGroundProperly(PackageDeliveryObject)
          local hasActionStarted = true
          while hasActionStarted do
            Citizen.Wait(0)
            local player = source
            local ped = GetPlayerPed(player)
            if GetDistanceBetweenCoords(GetEntityCoords(ped),businessLocations[selectedDest]["x"],  businessLocations[selectedDest]["y"],businessLocations[selectedDest]["z"],true) < 4.0 then
              Draw3DText2(businessLocations[selectedDest]["x"],  businessLocations[selectedDest]["y"],businessLocations[selectedDest]["z"] + 0.3,  tostring("~w~~g~[E]~w~ Pick Up Package"))
              if IsControlJustPressed(1,Keys["E"]) then
                local plyPos = GetEntityCoords(ped, false)
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                Citizen.Wait(0)
                exports["t0sic_loadingbar"]:StartDelayedFunction("PICKING UP...", math.random(5000,10000), function()
                  ClearPedTasks(PlayerPedId(-1))
                  DeleteObject(PackageDeliveryObject)
                  RemoveBlip(uberdeliveryblip)
                  takenpackage = true
                  hasActionStarted = false
                  end)
              end
            end
          end
        

--Delivery


  arrSize = tablelength(deliveryLocations) 

  selectedDest = math.random(1,arrSize)

  uberdeliveryblip = AddBlipForCoord(deliveryLocations[selectedDest]["x"],  deliveryLocations[selectedDest]["y"],  deliveryLocations[selectedDest]["z"])
  SetBlipSprite(uberdeliveryblip,1)
  SetBlipColour(uberdeliveryblip,16742399)
  SetBlipScale(uberdeliveryblip,1)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(deliveryLocations[selectedDest]["title"])
  EndTextCommandSetBlipName(uberdeliveryblip)
  SetNewWaypoint(deliveryLocations[selectedDest]["x"],  deliveryLocations[selectedDest]["y"])
  
  local hasActionStarted = true
  while hasActionStarted do
    Citizen.Wait(0)
    local player = source
    local ped = GetPlayerPed(player)
    if GetDistanceBetweenCoords(GetEntityCoords(ped),deliveryLocations[selectedDest]["x"],  deliveryLocations[selectedDest]["y"],deliveryLocations[selectedDest]["z"],true) < 4.0 then
      Draw3DText2(businessLocations[selectedDest]["x"],  deliveryLocations[selectedDest]["y"],deliveryLocations[selectedDest]["z"] + 0.3,  tostring("~w~~g~[E]~w~ Drop Package"))
      if IsControlJustPressed(1,Keys["E"]) then
        local plyPos = GetEntityCoords(ped, false)
        TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.Wait(0)
        exports["t0sic_loadingbar"]:StartDelayedFunction("DELIVERING...", math.random(5000,10000), function()
          ClearPedTasks(PlayerPedId(-1))
          local PackageDeliveryObject = CreateObject(GetHashKey("prop_cs_cardbox_01"), deliveryLocations[selectedDest]["x"],  deliveryLocations[selectedDest]["y"],deliveryLocations[selectedDest]["z"], true)
          PlaceObjectOnGroundProperly(PackageDeliveryObject)
          RemoveBlip(uberdeliveryblip)
          takenpackage = true
          hasActionStarted = false
          Citizen.Wait(60000)     
          DeleteObject(PackageDeliveryObject)  
        end)
      end
    end
  end
  
  TriggerServerEvent('esx_uber:pay',payment)
  TriggerEvent('showNotify', "You got: ~g~+" .. payment .. " ~w~~ sucessful delivery")



        
end)

 RegisterCommand("uberJob", function()
    
    TriggerServerEvent('esx_joblisting:setJob','uber')
    TriggerServerEvent('esx_uber:startWork')
   
  end, false)

 