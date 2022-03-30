local QBCore = exports['qb-core']:GetCoreObject()

local vehicles = {}

function getVehData(plate, callback)
    exports['oxmysql']:execute('SELECT * FROM player_vehicles', {},
    function(result)
        local foundIdentifier = nil
        for i=1, #result, 1 do
		    print(json.encode(result[i].vehicle))
            local vehicleData = result[i].vehicle
            if vehicleData.plate == plate then
                foundIdentifier = result[i].citizenid
                break
            end
        end
        if foundIdentifier ~= nil then
            exports['oxmysql']:execute("SELECT * FROM players WHERE citizenid = @citizenid", {['@citizenid'] = Player.PlayerData.citizenid},
            function(result)
                local ownerName = result[1].firstname .. " " .. result[1].lastname

                local info = {
                    plate = plate,
                    owner = ownerName
                }
                callback(info)
            end
          )
        else -- if identifier is nil then...
          local info = {
            plate = plate
          }
          callback(info)
        end
    end)
  end

RegisterNetEvent("qb_nocarjack:setVehicleDoorsForEveryone")
AddEventHandler("qb_nocarjack:setVehicleDoorsForEveryone", function(veh, doors, plate)
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local veh_model = veh[1]
    local veh_doors = veh[2]
    local veh_plate = veh[3]

    if not vehicles[veh_plate] then
        getVehData(veh_plate, function(veh_data)
            if veh_data.plate ~= plate then
                local players = GetPlayers()
                for _,player in pairs(players) do
                    TriggerClientEvent("qb_nocarjack:setVehicleDoors", player, table.unpack(veh, doors))
                end
            end
        end)
        vehicles[veh_plate] = true
    end
end)