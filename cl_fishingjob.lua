local atZone = true
local reeledIn = false
local bite = false
local catch
local number = 0
local param1 = 0
local param2 = 0
local casted = false
local reward
local common_rewards = {"old_boot","boot_with_cash","bass_fish","haddock_fish","cod_fish"}
local uncommon_rewards = {"carp_fish", "pouting_fish", "sole_fish", "black_bream_fish"}
local rare_rewards = {"red_mullet_fish", "ling_fish", "catfish_fish"}
local very_rare_rewards = {"wreckfish_fish", "angel_shark_fish"}
local insane_rewards = {"red_scorpion_fish"}
local multiplier = 1
local hasJob = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if check_distance()[1] and not casted and hasJob then
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to start fishing")
            EndTextCommandDisplayHelp(0, false, true, -1)
            if IsControlJustReleased(0, 51) then
                Citizen.Wait(1)
                TriggerServerEvent('vrp_fishingjob:checks')
                reeledIn = false
                number = 0
                Citizen.Wait(1000)
                if casted then
                    if not IsPedUsingScenario(PlayerPedId(), "world_human_stand_fishing") then
                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_stand_fishing", 0, false)
                    end
                    param1 = math.random(5,79)
                    --local type = tostring(check_distance()[2])
                    catch = generate_reward("legal")
                    leeway, speed = generate_difficulty(catch)
                    param2 = param1+leeway
                    if not bite and check_distance()[1] then
                        while not reeledIn do
                            Citizen.Wait(1)
                            BeginTextCommandPrint("STRING")
                            AddTextComponentSubstringPlayerName("Waiting for Bite...")
                            EndTextCommandPrint(5000, 1)
                            if bite then
                                while not reeledIn and check_distance()[1] do
                                    if not IsPedUsingScenario(PlayerPedId(), "world_human_stand_fishing") then
                                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_stand_fishing", 0, false)
                                    end
                                    if number < 100 then
                                        Citizen.Wait(500)
                                        while number < 100 and not reeledIn do
                                            number = number + 1
                                            BeginTextCommandPrint("STRING")
                                            AddTextComponentSubstringPlayerName("Land ON or BETWEEN "..param1.." and "..param2..": "..number)
                                            EndTextCommandPrint(5000, 1)
                                            Citizen.Wait(speed)
                                        end
                                    end
                                    if number == 100 then
                                        Citizen.Wait(500)
                                        while number ~= 0 and not reeledIn do
                                            number = number - 1
                                            BeginTextCommandPrint("STRING")
                                            AddTextComponentSubstringPlayerName("Land ON or BETWEEN "..param1.." and "..param2..": "..number)
                                            EndTextCommandPrint(5000, 1)
                                            Citizen.Wait(speed)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if casted and bite and not reeledIn then
            if IsControlJustReleased(0, 51) then
                ClearPedTasks(PlayerPedId())
                if number >= param1 and number <= param2 then
                    TriggerServerEvent('vrp_fishingjob:addreward', {source, catch})
                    number = 0
                    reeledIn = true
                    bite = false
                    casted = false
                else
                    number = 0
                    reeledIn = true
                    bite = false
                    casted = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(math.random(20000, 40000))
        if casted and not reeledIn then
            bite = true
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local cfg = Config.sellLocations
        local coords = GetEntityCoords(PlayerPedId())
        for i=1, #cfg, 1 do
            local distance = Vdist(coords.x, coords.y, coords.z, cfg[i].x, cfg[i].y, cfg[i].z)
            if distance < 25 then
                if hasJob then
                    DrawMarker(27, cfg[i].x, cfg[i].y, cfg[i].z, 0, 0, 0, 0, 0, 0, 15.0, 15.0, 15.0, 0, 0, 255, 128, 0, 0, 2, 0, 0, 0, 0)
                    if distance < 8 then
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to sell fish")
                        EndTextCommandDisplayHelp(0, false, true, -1)
                        if IsControlJustReleased(0,51) then
                            TriggerServerEvent('vrp_fishingjob:sellfish')
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local hadJob = false
    local fishLocations = Config.Locations
    local sellLocations = Config.sellLocations
    local blip
    local blip2
    while true do
        TriggerServerEvent('vrp_fishingjob:hasjob') -- triggers event every 5 seconds that checks if you have the correct job, also allow for the rest of the script to work
        Citizen.Wait(5000)
        print(hasJob)
        if hasJob then
            hadJob = true
            for i=1, #fishLocations, 1 do
                blip = AddBlipForCoord(fishLocations[i].x, fishLocations[i].y, fishLocations[i].z)
                SetBlipSprite(blip, 540)
                SetBlipScale(blip, 0.5)
            end
            for i=1, #sellLocations, 1 do
                blip2 = AddBlipForCoord(sellLocations[i].x, sellLocations[i].y, sellLocations[i].z)
                SetBlipSprite(blip2, 207)
                SetBlipScale(blip2, 1.5)
            end
        -- elseif not hasJob and hadJob then
        --     for i=1, #fishLocations, 1 do
        --         RemoveBlip(blip)
        --     end
        --     for i=1, #fishLocations, 1 do
        --         RemoveBlip(blip2)
        --     end
        --     hadJob = false
        end
    end
end)

function check_distance()
    local coords = GetEntityCoords(PlayerPedId())
    local locations = Config.Locations
    local params
    for i=1, #locations, 1 do 
        local distance = Vdist(coords.x, coords.y, coords.z, locations[i].x, locations[i].y, locations[i].z)
        if distance < 6 then
            local type = locations[i].type
            params = {true, type}
        else
            params = {false}
        end
        if params[1] then
            return params
        end
    end
    return params
end

function generate_reward(type)
    local chance = 0
    if type == "legal" then
        chance = math.random(0, 1000)
        if chance < 500*multiplier then
            return common_rewards[math.random(1, #common_rewards)]
        elseif chance >= 500*multiplier and chance <= 800*multiplier then
            return uncommon_rewards[math.random(1, #uncommon_rewards)]
        elseif chance > 800*multiplier and chance <= 925*multiplier then
            return rare_rewards[math.random(1, #rare_rewards)]
        elseif chance > 925*multiplier and chance <= 995*multiplier then
            return very_rare_rewards[math.random(1, #very_rare_rewards)]
        elseif chance > 995*multiplier and chance <= 1000 then
            return insane_rewards[math.random(1, #insane_rewards)]
        end
    end
end

function generate_difficulty(reward)

    local function tableContains(tbl, element)
        for _, v in ipairs(tbl) do
            if (rawequal(v, element)) then
                return true;
            end
        end
        return false;
    end

    if tableContains(common_rewards, reward) then
        return math.random(10,20), math.random(40,50)
    elseif tableContains(uncommon_rewards, reward) then
        return math.random(10,15), math.random(35,40)
    elseif tableContains(rare_rewards, reward) then
        return math.random(8,12), math.random(25,35)
    elseif tableContains(very_rare_rewards, reward) then
        return math.random(6,10), math.random(25, 30)
    elseif tableContains(insane_rewards, reward) then
        return math.random(4,6), math.random(20,25)
    end
end

RegisterNetEvent('vrp_fishingjob:modifyMultiplier')
AddEventHandler('vrp_fishingjob:modifyMultiplier', function(multiplerValue)
    if multiplerValue and not casted then
        if multiplerValue ~= 0 then
            if multiplerValue == 1 then
                multiplier = 1
                casted = true
            elseif multiplerValue == 0.99 then
                multiplier = 0.99
                casted = true
            elseif multiplerValue == 0.98 then
                multiplier = 0.98
                casted = true
            end
        else
            SetNotificationTextEntry( "STRING" )
            AddTextComponentString("~r~You have no bait!")
            DrawNotification( false, false )
        end
    else
        SetNotificationTextEntry( "STRING" )
        AddTextComponentString("~r~Not a Fisherman!")
        DrawNotification( false, false )
    end
end)

RegisterNetEvent('vrp_fishingjob:sethasjob')
AddEventHandler('vrp_fishingjob:sethasjob', function(status)
    if status then
        hasJob = true
    else
        hasJob = false
    end
end)