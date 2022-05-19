local mod = RegisterMod("InVerse", 1)
InVerse = mod

--[[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣤⣤⣤⣤⣶⣦⣤⣄⡀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠛⠉⠙⠛⠛⠛⠛⠻⢿⣿⣷⣤⡀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠋⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠈⢻⣿⣿⡄
⠀⠀⠀⠀⠀⠀⠀⣸⣿⡏⠀⠀⠀⣠⣶⣾⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣄
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⢰⣿⣿⣯⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⡄
⠀⠀⣀⣤⣴⣶⣶⣿⡟⠀⠀⠀⢸⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷
⠀⢰⣿⡟⠋⠉⣹⣿⡇⠀⠀⠀⠘⣿⣿⣿⣿⣷⣦⣤⣤⣤⣶⣶⣶⣶⣿⣿⣿
⠀⢸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃
⠀⣸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⡿⠿⠿⠛⢻⣿⡇
⠀⣿⣿⠁⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣧⠀⠀                               ⣠⣤⣤⣤⣤⣤⣶⣦⣤⣄⡀
⠀⣿⣿⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀                            ⢀⣴⣿⡿⠛⠉⠙⠛⠛⠛⠛⠻⢿⣿⣷⣤⡀
⠀⣿⣿⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀                          ⣼⣿⠋⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠈⢻⣿⣿⡄
⠀⢿⣿⡆⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀                        ⠀⣸⣿⡏⠀⠀⠀⣠⣶⣾⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣄
⠀⠸⣿⣧⡀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠃⠀⠀                        ⠀⣿⣿⠁⠀⠀⢰⣿⣿⣯⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⡄
⠀⠀⠛⢿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⣰⣿⣿⣷⣶⣶⣶⣶⠶⠀⢠⣿⣿⠀⠀⠀                 ⠀⣀⣤⣴⣶⣶⣿⡟⠀⠀⠀⢸⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⣽⣿⡏⠁⠀⠀⢸⣿⡇⠀⠀⠀                 ⠀⢰⣿⡟⠋⠉⣹⣿⡇⠀⠀⠀⠘⣿⣿⣿⣿⣷⣦⣤⣤⣤⣶⣶⣶⣶⣿⣿⣿
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⢹⣿⡆⠀⠀⠀⣸⣿⠇⠀⠀⠀                  ⢸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃
⠀⠀⠀⠀⠀⠀⠀⢿⣿⣦⣄⣀⣠⣴⣿⣿⠁⠀⠈⠻⣿⣿⣿⣿⡿⠏⠀⠀⠀⠀                ⠀⣸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⡿⠿⠿⠛⢻⣿⡇
⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠿⠿⠿⠿⠋⠁⠀⠀⠀⠀⠀                              ⠸⣿⣧⡀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠃
                                                       ⠀⠀⠛⢿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⣰⣿⣿⣷⣶⣶⣶⣶⠶⠀⢠⣿⣿
                                                       ⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⣽⣿⡏⠁⠀⠀⢸⣿⡇
                                                       ⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⢹⣿⡆⠀⠀⠀⣸⣿⠇
                                                       ⠀⠀⠀⠀⠀⠀⠀⢿⣿⣦⣄⣀⣠⣴⣿⣿⠁⠀⠈⠻⣿⣿⣿⣿⡿⠏
                                                      ⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠿⠿⠿⠿⠋⠁
]]






























---------------------------------------------------------------
---------------------------Savedata----------------------------
local function Copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[Copy(k, s)] = Copy(v, s) end
    return res
end

local json = require("json")

local baseData = {
    Players = {},
    Cards = {},
    DreamBookCharges = { 0, 0, 0, 0, 0, 0, 0, 0 }
}
for i = 1, 8 do
    table.insert(baseData.Players, {
        HaveBR = false,
        ItemsRemoveNextFloor = {},
        ItemsRemoveNextRoom = {},
        TrinketsRemoveNextFloor = {}
    })
end
local GlobalData = {
    CardsCanSpawn = {},
    TrinketsCanSpawn = {},
    ItemsCanSpawn = {},
    Unlocked = {}
}
mod.Data = {}
if mod:HasData() then
    mod.Data = json.decode(mod:LoadData())
else
    mod.Data = Copy(baseData)
    mod.Data.GlobalData = Copy(GlobalData)
end

function mod:SaveGame(ShouldSave)
    if ShouldSave then
        mod:SaveData(json.encode(mod.Data))
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveGame)

function mod:OnGameStart(player)
    local isContinued = Game():GetFrameCount() ~= 0
    if not isContinued and mod.GetPlayerNum(player) then
        local gd = Copy(mod.Data.GlobalData)
        mod.Data = Copy(baseData)
        for num = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(num - 1)
            mod.Data.Players[num].HaveBR = player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        end
        mod.Data.GlobalData = gd
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.OnGameStart)

---------------------------------------------------------------
-----------------------------Main------------------------------
function mod._if(cond, a, b)
    if cond then return a else return b end
end

function mod.GetPlayerNum(player)
    for i = 1, Game():GetNumPlayers() do
        if Isaac.GetPlayer(i - 1).Index == player.Index then
            return i
        end
    end
end

function mod.rand(min, max, rng)
    --[[if not rng then
        rng = RNG()
        rng:SetSeed(Random(), 35)
    end
    return rng:RandomInt(max - min + 1) + min]]
    return math.random(min, max)
end

function mod.AddTrinketAsItem(player, trinket)
    local trinket1 = player:GetTrinket(0)
    local trinket2 = player:GetTrinket(1)
    if trinket1 ~= 0 then player:TryRemoveTrinket(trinket1) end
    if trinket2 ~= 0 then player:TryRemoveTrinket(trinket2) end
    player:AddTrinket(trinket)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false)
    if trinket1 ~= 0 then player:AddTrinket(trinket1) end
    if trinket2 ~= 0 then player:AddTrinket(trinket2) end
end

function mod.keys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    return keys
end

local function HideWisp(wisp)
    wisp = wisp:ToFamiliar()
    wisp:RemoveFromOrbit()
    wisp.Position = Vector(-100, -100)
    wisp:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
    wisp.Visible = false
    --wisp.Color = Color(0, 0, 0)
    wisp.CollisionDamage = 0
    wisp.EntityCollisionClass = 0
    wisp.Player:RemoveCostume(Isaac.GetItemConfig():GetCollectible(wisp.SubType))
end

function mod.AddItemForFloor(player, item)
    local num = mod.GetPlayerNum(player)
    local wisp = player:AddItemWisp(item, Vector.Zero)
    HideWisp(wisp)
    table.insert(mod.Data.Players[num].ItemsRemoveNextFloor, item)
end
function mod.AddItemForRoom(player, item)
    local num = mod.GetPlayerNum(player)
    local wisp = player:AddItemWisp(item, Vector.Zero)
    HideWisp(wisp)
    table.insert(mod.Data.Players[num].ItemsRemoveNextRoom, item)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local num = i + 1
        for j, elem in pairs(mod.Data.Players[num].ItemsRemoveNextFloor) do
            local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, elem)
            for w = 1, #wisps do
                if wisps[w]:ToFamiliar().Player.Index == player.Index and not wisps[w].Visible and wisps[w].EntityCollisionClass == 0 then
                    wisps[w].Position = Vector(-300, -300)
                    wisps[w]:Kill()
                    SFXManager():Stop(SoundEffect.SOUND_STEAM_HALFSEC)
                    mod.Data.Players[num].ItemsRemoveNextFloor[j] = nil
                end
            end
        end
        for j, elem in pairs(mod.Data.Players[num].TrinketsRemoveNextFloor) do
            if player:TryRemoveTrinket(elem) then
                mod.Data.Players[num].TrinketsRemoveNextFloor[j] = nil
            end
        end
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for i = 0, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)
        local num = i + 1
        for j, elem in pairs(mod.Data.Players[num].ItemsRemoveNextRoom) do
            local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, elem)
            for w = 1, #wisps do
                if wisps[w]:ToFamiliar().Player.Index == player.Index and wisps[w].EntityCollisionClass == 0 then
                    wisps[w].Position = Vector(-300, -300)
                    wisps[w]:Kill()
                    SFXManager():Stop(SoundEffect.SOUND_STEAM_HALFSEC)
                    mod.Data.Players[num].ItemsRemoveNextRoom[j] = nil
                end
            end
        end
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    for i = 0, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)
        local num = i + 1
        for j, elem in pairs(mod.Data.Players[num].ItemsRemoveNextRoom) do
            local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, elem)
            for w = 1, #wisps do
                if wisps[w]:ToFamiliar().Player.Index == player.Index and wisps[w].Visible then
                    HideWisp(wisps[w])
                end
            end
        end
    end
end)

mod.Characters = {}
function mod:onCache(player, cacheFlag)
    local charType = player:GetPlayerType()
    if mod.Characters[charType] then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = (player.Damage + mod.Characters[charType].DAMAGE) * mod.Characters[charType].DAMAGE_MULT
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            --[[local baseTears = 30.0 / (10 + 1)
            local tears = 30.0 / (player.MaxFireDelay + 1)
            local newTears = baseTears * mod.Characters[charType].FIREDELAY + tears - baseTears
            player.MaxFireDelay = 30 / newTears - 1]]
            player.MaxFireDelay = player.MaxFireDelay / mod.Characters[charType].FIREDELAY
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + mod.Characters[charType].SHOTSPEED
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - mod.Characters[charType].TEARHEIGHT
            player.TearFallingSpeed = player.TearFallingSpeed + mod.Characters[charType].TEARFALLINGSPEED
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + mod.Characters[charType].SPEED
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + mod.Characters[charType].LUCK
        elseif cacheFlag == CacheFlag.CACHE_FLYING and mod.Characters[charType].FLYING then
            player.CanFly = true
        elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | mod.Characters[charType].TEARFLAG
        elseif cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = mod.Characters[charType].TEARCOLOR
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local entities = Game():GetRoom():GetEntities()
    --[[for i = 0, #entities - 1 do
        local ent = entities:Get(i)
        print(ent.Type, ent.Variant, ent.SubType, ent:GetSprite().Color.R, ent:GetSprite().Color.G, ent:GetSprite().Color.B)
    end]]
    --[[for i = 1, 500 do
        if SFXManager():IsPlaying(i) then
            print(i)
        end
    end]]
end)

dofile("scripts/misc/unlocks.lua")

dofile("scripts/characters/Dream")
dofile("scripts/characters/DreamB")

dofile("scripts/items/DreamBook")
dofile("scripts/items/Momentuum")

dofile("scripts/compat/EID.lua")
dofile("scripts/compat/pog.lua")