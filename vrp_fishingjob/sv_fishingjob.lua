local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_fishingjob")

local common_rewards = {"bass_fish","haddock_fish","cod_fish"}
local uncommon_rewards = {"carp_fish", "pouting_fish", "sole_fish", "black_bream_fish"}
local rare_rewards = {"red_mullet_fish", "ling_fish", "catfish_fish"}
local very_rare_rewards = {"wreckfish_fish", "angel_shark_fish"}
local insane_rewards = {"red_scorpion_fish"}

RegisterServerEvent('vrp_fishingjob:checks')
AddEventHandler('vrp_fishingjob:checks', function()
    local user_id = vRP.getUserId({source})

    if vRP.getInventoryItemAmount({user_id, "high_tier_bait"}) >= 1 then -- high tier bait
        vRP.tryGetInventoryItem({user_id, "high_tier_bait", 1})
        TriggerClientEvent('vrp_fishingjob:modifyMultiplier', source, 0.98)
    elseif vRP.getInventoryItemAmount({user_id, "mid_tier_bait"}) >= 1 then -- mid tier bait
        vRP.tryGetInventoryItem({user_id, "mid_tier_bait", 1})
        TriggerClientEvent('vrp_fishingjob:modifyMultiplier', source, 0.99)
    elseif vRP.getInventoryItemAmount({user_id, "low_tier_bait"}) >= 1 then -- low tier bait
        vRP.tryGetInventoryItem({user_id, "low_tier_bait", 1})
        TriggerClientEvent('vrp_fishingjob:modifyMultiplier', source, 1)
    else
        TriggerClientEvent('vrp_fishingjob:modifyMultiplier', source, 0)
    end
end)

RegisterServerEvent('vrp_fishingjob:hasjob')
AddEventHandler('vrp_fishingjob:hasjob', function()
    local user_id = vRP.getUserId({source})
    local hasPerms = vRP.hasGroup({user_id, "Fisher"})
    if hasPerms then
        TriggerClientEvent('vrp_fishingjob:sethasjob', source, true)
    else
        TriggerClientEvent('vrp_fishingjob:sethasjob', source, false)
    end
end)

RegisterServerEvent('vrp_fishingjob:addreward')
AddEventHandler('vrp_fishingjob:addreward', function(reward)
    local user_id = vRP.getUserId({source})
    local cfg = Config.sellPrices
    local reward = reward[2]
    if reward == "boot_with_cash" then
        vRP.giveMoney({user_id, cfg.Common})
        vRP.giveInventoryItem({user_id, "old_boot", 1, true})
    else
        vRP.giveInventoryItem({user_id, reward, 1, true})
    end
    CancelEvent()
end)

RegisterServerEvent('vrp_fishingjob:sellfish')
AddEventHandler('vrp_fishingjob:sellfish', function()
    local cfg = Config.sellPrices
    local user_id = vRP.getUserId({source})
    for i=1, #common_rewards, 1 do
        while vRP.getInventoryItemAmount({user_id, common_rewards[i]}) >= 1 do
            Citizen.Wait(1000)
            vRP.tryGetInventoryItem({user_id, common_rewards[i], 1})
            vRP.giveMoney({user_id, cfg.Common})
        end
    end
    for i=1, #uncommon_rewards, 1 do
        while vRP.getInventoryItemAmount({user_id, uncommon_rewards[i]}) >= 1 do
            Citizen.Wait(1000)
            vRP.tryGetInventoryItem({user_id, uncommon_rewards[i], 1})
            vRP.giveMoney({user_id, cfg.Uncommon})
        end
    end
    for i=1, #rare_rewards, 1 do
        while vRP.getInventoryItemAmount({user_id, rare_rewards[i]}) >= 1 do
            Citizen.Wait(1000)
            vRP.tryGetInventoryItem({user_id, rare_rewards[i], 1})
            vRP.giveMoney({user_id, cfg.Rare})
        end
    end
    for i=1, #very_rare_rewards, 1 do
        while vRP.getInventoryItemAmount({user_id, very_rare_rewards[i]}) >= 1 do
            Citizen.Wait(1000)
            vRP.tryGetInventoryItem({user_id, very_rare_rewards[i], 1})
            vRP.giveMoney({user_id, cfg.Very_rare})
        end
    end
    for i=1, #insane_rewards, 1 do
        while vRP.getInventoryItemAmount({user_id, insane_rewards[i]}) >= 1 do
            Citizen.Wait(1000)
            vRP.tryGetInventoryItem({user_id, insane_rewards[i], 1})
            vRP.giveMoney({user_id, cfg.Insane})
        end
    end
end)

