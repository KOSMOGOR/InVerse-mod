local mod = InVerse
local callbacks = {}

mod.PLAYER_TIGRO = Isaac.GetPlayerTypeByName("Teegro")
local HunterKeyVariant = Isaac.GetEntityVariantByName("Hunter Key")
local HunterKeyPartVariant = Isaac.GetEntityVariantByName("Hunter Key Part")
local KeyPriceVariant = Isaac.GetEntityVariantByName("Key Price")
local HunterChestVariant = Isaac.GetEntityVariantByName("Hunter Chest")
local DoubleHunterKeyVariant = Isaac.GetEntityVariantByName("Double Hunter Key")
local HalfHunterKeyVariant = Isaac.GetEntityVariantByName("Half Hunter Key")
local RenderSincePickup = 0

function callbacks:SetDefaultValues(player) -- Set Defaul Values
    if not mod.Data.Teegro then
        mod.Data.Teegro = {
            checkedItems = {},
            lockedItems = {},
            keyShards = 4,
            itemsDeleteOnNewRoom = {},
            hadDamageThisRoom = false,
            lastRoom = 0,
            lastRoomCheckClear = 0,
            bossWasKilled = false,
            checkedRooms = {},
            chestDrops = {}
        }
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.SetDefaultValues)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.SetDefaultValues)

local function SelectRandomWeights(table, rng)
    local sum = 0
    for i = 1, #table do
        sum = sum + table[i][1]
    end
    local n = mod.rand(1, sum, rng)
    sum = 0
    for i = 1, #table do
        sum = sum + table[i][1]
        if n <= sum then
            return table[i][2]
        end
    end
end

local function GetRandomItem(minimumQuality, pools, rng)
    local itemPool = Game():GetItemPool()
    local items = {}
    if pools == nil then pools = {0, 1, 2, 3, 4, 5, 6, 26} end
    for _, pool in ipairs(pools) do
        itemPool:ResetRoomBlacklist()
        while true do
            local itemId = itemPool:GetCollectible(pool, false, 1, CollectibleType.COLLECTIBLE_DADS_NOTE)
            if itemId == CollectibleType.COLLECTIBLE_DADS_NOTE then break end
            if Isaac.GetItemConfig():GetCollectible(itemId).Quality >= minimumQuality then
                table.insert(items, itemId)
            end
            itemPool:AddRoomBlacklist(itemId)
        end
        itemPool:ResetRoomBlacklist()
        if #items == 0 then items = {CollectibleType.COLLECTIBLE_BREAKFAST} end
    end
    local item = items[mod.rand(1, #items, rng)]
    itemPool:RemoveCollectible(item)
    return item
end

local function GetPickupInd(pickup)
    return tostring(pickup.InitSeed)
end

local function GetHunterKeyValue(pickup)
    return ({
        [HunterKeyVariant] = 4,
        [HunterKeyPartVariant] = 1,
        [DoubleHunterKeyVariant] = 8,
        [HalfHunterKeyVariant] = 2,
    })[pickup.Variant]
end

mod.Characters[mod.PLAYER_TIGRO] = {
    Hair = Isaac.GetCostumeIdByPath("gfx/characters/teegro_hair.anm2"),
    Tail = Isaac.GetCostumeIdByPath("gfx/characters/teegro_tail.anm2"),
    DAMAGE = 1.6,
    DAMAGE_MULT = 1,
    FIREDELAY = 0.7,
    SPEED = 0.1,
    SHOTSPEED = 0.2,
    TEARRANGE = -80,
    LUCK = 0,
    FLYING = false,
    TEARFLAG = 0,
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
}

function callbacks:OnInit(player)
    if player:GetPlayerType() == mod.PLAYER_TIGRO then
        player:AddNullCostume(mod.Characters[mod.PLAYER_TIGRO].Hair)
        player:AddNullCostume(mod.Characters[mod.PLAYER_TIGRO].Tail)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.OnInit)

local ItemChainsVarian = Isaac.GetEntityVariantByName("ItemChains")
local function LockItemSprite(item, touch)
    if item.Child then
        if item.Child.Child then
            item.Child.Child:Remove()
        end
        item.Child:Remove()
    end
    local ind = GetPickupInd(item)
    if not touch then
        local effect1 = Isaac.Spawn(1000, ItemChainsVarian, 0, item.Position, Vector.Zero, nil):ToEffect()
        effect1:GetSprite():Play("Front", true)
        effect1.DepthOffset = 5
        effect1:FollowParent(item)
        local effect2 = Isaac.Spawn(1000, ItemChainsVarian, 0, item.Position, Vector.Zero, nil):ToEffect()
        effect2:GetSprite():Play("Back", true)
        effect2.DepthOffset = -5
        effect2:FollowParent(item)
        item.Child = effect1
        item.Child.Child = effect2
        effect1.Parent = item
        effect2.Parent = effect1
    else
        item.AutoUpdatePrice = false
        item.Price = -10
        local effect = Isaac.Spawn(1000, KeyPriceVariant, 0, item.Position, Vector.Zero, nil):ToEffect()
        effect.DepthOffset = -10
        effect.SpriteOffset = Vector(0, 10)
        effect:GetSprite():SetFrame("Idle", mod.Data.Teegro.lockedItems[ind].cost // 4 - 1)
        item.Child = effect
        effect.Parent = item
    end
end

function callbacks:UpdateChainsAndPrice(effect)
    if effect.Variant == ItemChainsVarian or effect.Variant == KeyPriceVariant then
        if not (effect.Parent and effect.Parent:Exists()) then
            effect:Remove()
        elseif effect.Position.X ~= effect.Parent.Position.X or effect.Position.Y ~= effect.Parent.Position.Y then
            effect.Position = Vector(effect.Parent.Position.X, effect.Parent.Position.Y)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, callbacks.UpdateChainsAndPrice)

function callbacks:OnPickupInit(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    if Game():GetLevel():GetCurrentRoomDesc().GridIndex == GridRooms.ROOM_GENESIS_IDX then return end
    if Game():GetLevel():GetCurrentRoomDesc().Data.StageID == 35 then return end -- Death certificate rooms (originally Home rooms)
    local ind = GetPickupInd(pickup)
    if pickup.Variant == PickupVariant.PICKUP_COIN and not mod.Data.Teegro.checkedItems[ind] then
        if Isaac.GetPlayer(0):GetNumCoins() >= 30 and mod.rand(1, 10, pickup.InitSeed) == 1 then
            pickup:Morph(5, HunterKeyPartVariant, 0, true, false)
        else
            mod.Data.Teegro.checkedItems[ind] = true
        end
    end
    if mod.Data.Teegro.checkedItems[ind] and pickup.Variant == 100 and mod.Data.Teegro.checkedItems[ind] ~= pickup.SubType then
        mod.Data.Teegro.checkedItems[ind] = nil
    end
    if mod.Data.Teegro.lockedItems[ind] and mod.Data.Teegro.lockedItems[ind].Variant == 100 and pickup.Variant ~= 100 then
        mod.Data.Teegro.lockedItems[ind] = nil
    end
    if mod.Data.Teegro.lockedItems[ind] and not pickup.Child then
        LockItemSprite(pickup, mod.Data.Teegro.lockedItems[ind].touch)
    end
    if pickup.Variant == 100 and not mod.Data.Teegro.checkedItems[ind]  and pickup:GetSprite():GetAnimation() ~= "Empty"then
        mod.Data.Teegro.checkedItems[ind] = pickup.SubType
        if Isaac.GetItemConfig():GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST) or Game():GetRoom():GetType() == RoomType.ROOM_BOSS then return end
        local cost = 4
        local touch = false
        if pickup.Price ~= 0 then
            if mod.trueTable({-2, -3, -4, -8, -9, 30})[pickup.Price] then
                cost = 12
                touch = true
            elseif mod.trueTable({-1, -7, 15})[pickup.Price] then
                cost = 8
                touch = true
            elseif mod.trueTable({-6, -10})[pickup.Price] or pickup.Price > 0 then
                cost = 4
                touch = true
            end
            pickup.Price = 0
        end
        mod.Data.Teegro.lockedItems[ind] = {
            cost = cost,
            touch = touch,
            Variant = pickup.Variant,
            SubType = pickup.SubType
        }
        LockItemSprite(pickup, touch)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.OnPickupInit)

function callbacks:LockedItemInteraction(pickup, collider, low)
    if collider:ToPlayer() == nil or pickup:GetSprite():GetAnimation() == "Empty" then return end
    if not collider:ToPlayer():IsItemQueueEmpty() then return end
    local ind = GetPickupInd(pickup)
    if mod.Data.Teegro.lockedItems[ind] and pickup.Child then
        if pickup.Child:GetSprite():GetAnimation() ~= "FrontUnlocking" and mod.Data.Teegro.keyShards >= mod.Data.Teegro.lockedItems[ind].cost then
            mod.Data.Teegro.keyShards = mod.Data.Teegro.keyShards - mod.Data.Teegro.lockedItems[ind].cost
            if pickup.Child and pickup.Child.Child then
                pickup.Child:GetSprite():Play("FrontUnlocking")
                pickup.Child.Child:GetSprite():Play("BackUnlocking")
                SFXManager():Play(SoundEffect.SOUND_CHAIN_BREAK)
            elseif pickup.Child then
                if mod.Data.Teegro.lockedItems[ind].touch == true and Game():GetRoom():GetType() == RoomType.ROOM_DEVIL then
                    Game():AddDevilRoomDeal()
                end
                pickup.Child:Remove()
                mod.Data.Teegro.lockedItems[ind] = nil
            end
        end
        if mod.Data.Teegro.lockedItems[ind] then return mod.Data.Teegro.lockedItems[ind].touch end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.LockedItemInteraction)

function callbacks:UnlockItem(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local ind = GetPickupInd(pickup)
    if pickup.Variant == 100 and mod.Data.Teegro.lockedItems[ind] then
        if pickup.Child and pickup.Child:GetSprite():IsFinished("FrontUnlocking") then
            mod.Data.Teegro.lockedItems[ind] = nil
            pickup.Child.Child:Remove()
            pickup.Child:Remove()
        elseif pickup:GetSprite():GetAnimation() == "Empty" and pickup:GetSprite():GetOverlayFrame() == -1 then
            mod.Data.Teegro.lockedItems[ind] = nil
            pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.UnlockItem)

function callbacks:GrabHunterKey(pickup, collider, low)
    if collider:ToPlayer() == nil then return end
    local value = GetHunterKeyValue(pickup)
    if value then
        if pickup:GetSprite():IsPlaying("Collect") then return true end
        pickup:GetSprite():Play("Collect")
        local keys1 = mod.Data.Teegro.keyShards // 4
        mod.Data.Teegro.keyShards = mod.Data.Teegro.keyShards + value
        local keys2 = mod.Data.Teegro.keyShards // 4
        SFXManager():Play(
            mod._if(keys2 > keys1, SoundEffect.SOUND_DEATH_BURST_BONE, SoundEffect.SOUND_BONE_HEART)
        )
        RenderSincePickup = 0
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.GrabHunterKey)

function callbacks:OnChestInit(pickup)
    if pickup.Variant ~= HunterChestVariant then return end
    local ind = GetPickupInd(pickup)
    if not mod.Data.Teegro.checkedItems[ind] then
        mod.Data.Teegro.checkedItems[ind] = true
        local rng = RNG()
        rng:SetSeed(pickup.InitSeed, 35)
        local spawnPickups = {}
        local lowerBound = mod._if(Game():GetLevel():GetStage() == LevelStage.STAGE6, 4, 1)
        local rand = mod.rand(lowerBound, 5, rng)
        if rand == 1 then
            local rand2 = mod.rand(1, 3, rng)
            local rand3 = mod.rand(3, 7, rng)
            if rand2 == 1 then
                table.insert(spawnPickups, {
                    Variant = PickupVariant.PICKUP_BOMB,
                    SubType = BombSubType.BOMB_GOLDEN,
                    anm2 = "005.043_golden bomb"
                })
            elseif rand2 == 2 then
                table.insert(spawnPickups, {
                    Variant = PickupVariant.PICKUP_KEY,
                    SubType = KeySubType.KEY_GOLDEN,
                    anm2 = "005.032_golden key"
                })
            else
                local tt = Game():GetItemPool():GetTrinket() | TrinketType.TRINKET_GOLDEN_FLAG
                Game():GetItemPool():RemoveTrinket(tt)
                -- local anm2 = Isaac.GetItemConfig():GetTrinket(tt).GfxFileName
                table.insert(spawnPickups, {
                    Variant = PickupVariant.PICKUP_TRINKET,
                    SubType = tt
                    -- anm2 = anm2:sub(5, #anm2 - 5)
                })
            end
            for _ = 1, rand3 do
                local coin = SelectRandomWeights({
                    {9263, {CoinSubType.COIN_PENNY, "005.021_penny"}},
                    {468, {CoinSubType.COIN_NICKEL, "005.022_nickel"}},
                    {100, {CoinSubType.COIN_DIME, "005.023_dime"}},
                    {94, {CoinSubType.COIN_LUCKYPENNY, "005.026_lucky penny"}},
                    {25, {CoinSubType.COIN_STICKYNICKEL, "005.025_sticky nickel"}},
                    {50, {CoinSubType.COIN_GOLDEN, "005.027_golden penny"}},
                })
                table.insert(spawnPickups, {
                    Variant = PickupVariant.PICKUP_COIN,
                    SubType = coin[1],
                    anm2 = coin[2]
                })
            end
        elseif rand == 2 then
            for _ = 1, 3 do
                local card = mod.rand(56, 77, rng)
                table.insert(spawnPickups, {
                    Variant = PickupVariant.PICKUP_TAROTCARD,
                    SubType = card,
                    anm2 = "005.300.14_reverse tarot card"
                })
            end
        elseif rand == 3 then
            local rand2 = mod.rand(3, 7, rng)
            for _ = 1, rand2 do
                table.insert(spawnPickups, {
                    Variant = HunterKeyPartVariant,
                    SubType = 0,
                    anm2 = "items/pickups/hunter_key_part"
                })
            end
        elseif rand == 4 or rand == 5 then
            local item = GetRandomItem(mod._if(rand == 2, 0, 2), mod._if(rand == 2, nil, {ItemPoolType.POOL_TREASURE}), rng)
            table.insert(spawnPickups, {
                Variant = 100,
                SubType = item
            })
        end
        mod.Data.Teegro.chestDrops[ind] = spawnPickups
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.OnChestInit)

function callbacks:OpenHunterChest(pickup, collider, low)
    if collider:ToPlayer() == nil then return end
    if pickup.Variant == HunterChestVariant and pickup:GetSprite():GetAnimation() == "Idle" and mod.Data.Teegro.keyShards >= 4 then
        mod.Data.Teegro.keyShards = mod.Data.Teegro.keyShards - 4
        SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN)
        local ind = GetPickupInd(pickup)
        local drop = mod.Data.Teegro.chestDrops[ind]
        if drop[1].Variant ~= 100 then
            for _, pickup1 in ipairs(drop) do
                local angle = math.rad(mod.rand(0, 359))
                local vec = Vector(math.cos(angle), math.sin(angle)) * 3
                Isaac.Spawn(5, pickup1.Variant, pickup1.SubType, pickup.Position, vec, nil)
            end
            pickup:GetSprite():Play("Open")
            mod.Data.Teegro.itemsDeleteOnNewRoom[GetPickupInd(pickup)] = true
        else
            local pos = pickup.Position
            local pickup2 = Isaac.Spawn(5, 100, drop[1].SubType, pos, Vector.Zero, nil)
            local ind2 = GetPickupInd(pickup2)
            mod.Data.Teegro.checkedItems[ind2] = pickup2.SubType
            pickup2:GetSprite():ReplaceSpritesheet(5, "gfx/teegro/Hunter_Chest_item.png")
            pickup2:GetSprite():LoadGraphics()
            pickup2:GetSprite():SetOverlayFrame("Alternates", 10)
            for i = 1, 4 do pickup2:Update() end
            pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.OpenHunterChest)

function callbacks:HunterKeyUpdate(pickup)
    if GetHunterKeyValue(pickup) then
        if pickup:GetSprite():IsPlaying("Collect") and pickup:GetSprite():GetFrame() >= 5 then
            pickup:Remove()
        elseif pickup:GetSprite():IsEventTriggered("DropSound") then
            SFXManager():Play(SoundEffect.SOUND_BONE_DROP)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.HunterKeyUpdate)

function callbacks:HunterChestUpdate(pickup)
    if pickup.Variant == HunterChestVariant then
        if pickup:GetSprite():IsEventTriggered("DropSound") then
            SFXManager():Play(SoundEffect.SOUND_CHEST_DROP)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.HunterChestUpdate)

function callbacks:SpawnHunterKey(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) or pickup.Variant == 100 then return end
    local ind = GetPickupInd(pickup)
    if mod.Data.Teegro.checkedItems[ind] then return end
    mod.Data.Teegro.checkedItems[ind] = true
    local rng = RNG()
    rng:SetSeed(pickup.InitSeed, 35)
    if pickup.Variant == 30 and pickup.Price == 0 then
        local keyChance = mod._if(mod.CharaterHasBirthright(mod.PLAYER_TIGRO), 20, 5)
        local upperBound = mod._if(mod.trueTable({RoomType.ROOM_SECRET, RoomType.ROOM_SUPERSECRET, RoomType.ROOM_ULTRASECRET})[Game():GetRoom():GetType()], 250 + keyChance, 1000)
        local r = mod.rand(1, upperBound, rng)
        if r <= keyChance then
            pickup:Morph(5, HunterKeyVariant, 0, true, true)
        elseif r <= 250 + keyChance then
            pickup:Morph(5, HunterKeyPartVariant, 0, true, true)
        end
    elseif pickup.Price ~= 0 then
        local r = mod.rand(1, 100, rng)
        if r <= 2 then
            pickup:Morph(5, HunterKeyVariant, 0, true, true)
            pickup.AutoUpdatePrice = false
            pickup.Price = 15
        elseif r <= 25 + 2 then
            pickup:Morph(5, HunterKeyPartVariant, 0, true, true)
            pickup.AutoUpdatePrice = false
            pickup.Price = 5
        end
    end
    local playerWithEquality = mod.CharaterHasTrinket(TrinketType.TRINKET_EQUALITY)
    local playerWithBundle = mod.CharaterHasItem(CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE)
    if (playerWithEquality and playerWithEquality:GetNumCoins() == playerWithEquality:GetNumBombs() and playerWithEquality:GetNumBombs() == playerWithEquality:GetNumKeys()) or
        (playerWithBundle and mod.rand(1, 2, rng) == 1) then
        if pickup.Variant == HunterKeyVariant then
            pickup:Morph(5, DoubleHunterKeyVariant, 0, true, true)
        elseif pickup.Variant == HunterKeyPartVariant then
            pickup:Morph(5, HalfHunterKeyVariant, 0, true, true)
        end
    end
    if GetHunterKeyValue(pickup) == 1 then
        pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pickups/pickup_hunter_key_part_" .. mod.rand(1, 4) .. ".png")
    elseif GetHunterKeyValue(pickup) == 2 then
        pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pickups/pickup_hunter_key_part_double_" .. mod.rand(1, 2) .. ".png")
    end
    pickup:GetSprite():LoadGraphics()
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.SpawnHunterKey)

function callbacks:DeleteItemOnNewRoom()
    local entities = Game():GetRoom():GetEntities()
    for i = 0, #entities - 1 do
        local ent = entities:Get(i)
        local ind = GetPickupInd(ent)
        if mod.Data.Teegro.itemsDeleteOnNewRoom[ind] then
            ent:Remove()
            mod.Data.Teegro.itemsDeleteOnNewRoom[ind] = nil
            mod.Data.Teegro.lockedItems[ind] = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.DeleteItemOnNewRoom)

function callbacks:LockPickupSpritesOnNewRoom()
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local pickup = entity:ToPickup()
        if pickup then
            local ind = GetPickupInd(pickup)
            if mod.Data.Teegro.lockedItems[ind] then
                LockItemSprite(pickup, mod.Data.Teegro.lockedItems[ind].touch)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.LockPickupSpritesOnNewRoom)

function callbacks:CheckRoomReward()
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local room = Game():GetRoom()
    local gridIndex = Game():GetLevel():GetCurrentRoomDesc().SafeGridIndex
    local entities = room:GetEntities()
    if mod.Data.Teegro.lastRoomCheckClear == gridIndex and room:IsClear() then
        local hasRoomReward = false
        for i = 0, #entities - 1 do
            local ent = entities:Get(i)
            if ent.Type == 5 then
                if ent.DropSeed == room:GetAwardSeed() then
                    hasRoomReward = true
                    break
                end
            end
        end
        local rng = RNG()
        rng:SetSeed(room:GetAwardSeed(), 35)
        if not hasRoomReward and room:GetType() ~= RoomType.ROOM_BOSS then
            local key = SelectRandomWeights({
                {96, KeySubType.KEY_NORMAL},
                {2, KeySubType.KEY_GOLDEN},
                {2, KeySubType.KEY_CHARGED}
            }, rng)
            Isaac.Spawn(5, PickupVariant.PICKUP_KEY, key,
                room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0), Vector.Zero, nil
            )
        end
        if not mod.Data.Teegro.hadDamageThisRoom then
            local r = mod.rand(1, 100, rng)
            local stage = Game():GetLevel():GetStage()
            local roomChance = mod._if(LevelStage.STAGE4_1 <= stage and stage <= LevelStage.STAGE8, 8, 5)
            if r <= 47 + roomChance then
                Isaac.Spawn(5, mod._if(r <= roomChance, HunterChestVariant, HunterKeyPartVariant), 0,
                    room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0), Vector.Zero, nil
                )
            end
        end
    end
    if not room:IsClear() then
        mod.Data.Teegro.lastRoomCheckClear = gridIndex
    else
        mod.Data.Teegro.lastRoomCheckClear = nil
    end
    if room:IsClear() then mod.Data.Teegro.bossWasKilled = false end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, callbacks.CheckRoomReward)

function callbacks:SpawnKeyAfterBossDeath(npc)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    if npc:IsBoss() and not mod.Data.Teegro.bossWasKilled then
        if mod.trueTable({RoomType.ROOM_BOSS, RoomType.ROOM_DEVIL, RoomType.ROOM_ANGEL, RoomType.ROOM_MINIBOSS, RoomType.ROOM_SHOP, RoomType.ROOM_CHALLENGE})[Game():GetRoom():GetType()] then
            local spawn = {1, HunterKeyVariant}
            if mod.trueTable({RoomType.ROOM_MINIBOSS, RoomType.ROOM_SHOP})[Game():GetRoom():GetType()] or Game():GetRoom():GetType() == RoomType.ROOM_CHALLENGE and Game():GetLevel():HasBossChallenge() then
                spawn = {mod.rand(1, 3, Game():GetRoom():GetAwardSeed()), HunterKeyPartVariant}
            end
            for _ = 1, spawn[1] do
                local angle = math.rad(mod.rand(0, 359))
                local vec = Vector(math.cos(angle), math.sin(angle)) * 3
                Isaac.Spawn(5, spawn[2], 0, npc.Position, vec, nil)
            end
        end
        mod.Data.Teegro.bossWasKilled = true
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, callbacks.SpawnKeyAfterBossDeath)

function callbacks:CheckDamageThisRoom(entity, amount, flags, source)
    local player = entity:ToPlayer()
    if not player then return end
    if flags & (DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_NO_MODIFIERS) ~= 0 then return end
    mod.Data.Teegro.hadDamageThisRoom = true
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, callbacks.CheckDamageThisRoom)

function callbacks:ResetTakenDamageOnNewRoom()
    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()
    if roomDescriptor.SafeGridIndex ~= mod.Data.Teegro.lastRoom then
        mod.Data.Teegro.hadDamageThisRoom = false
        mod.Data.Teegro.lastRoom = roomDescriptor.SafeGridIndex
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.ResetTakenDamageOnNewRoom)

function callbacks:SpawnChestInNewRoom()
    local descriptor = Game():GetLevel():GetCurrentRoomDesc()
    if not mod.Data.Teegro.checkedRooms[descriptor.SafeGridIndex] and
    (mod.trueTable({GridRooms.ROOM_BLACK_MARKET_IDX, GridRooms.ROOM_SECRET_SHOP_IDX})[descriptor.GridIndex] or Game():GetRoom():GetType() == RoomType.ROOM_DEVIL and not descriptor.SurpriseMiniboss) then
        mod.Data.Teegro.checkedRooms[descriptor.SafeGridIndex] = true
        local pos = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetRandomPosition(0), 0, false, false)
        Isaac.Spawn(5, HunterChestVariant, 0, pos, Vector.Zero, nil)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.SpawnChestInNewRoom)

function callbacks:ResetCheckedRoom()
    mod.Data.Teegro.checkedRooms = {}
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, callbacks.ResetCheckedRoom)

function callbacks:BirthrightEffect()
    local stage = Game():GetLevel():GetStage()
    if mod.CharaterHasBirthright(mod.PLAYER_TIGRO) and stage ~= LevelStage.STAGE6 then
        local rng = RNG()
        rng:SetSeed(Game():GetRoom():GetAwardSeed(), 35)
        for i = 1, 4 do
            local pos = Vector(200 + mod._if(i % 2 == 0, 240, 0), 200 + mod._if(i > 2, 160, 0))
            local item = GetRandomItem(0, Game():GetRoom():GetAwardSeed())
            local pickup = Isaac.Spawn(5, 100, item, pos, Vector.Zero, nil):ToPickup()
            local ind = GetPickupInd(pickup)
            mod.Data.Teegro.itemsDeleteOnNewRoom[ind] = true
            mod.Data.Teegro.checkedItems[ind] = true
            mod.Data.Teegro.lockedItems[ind] = {
                cost = mod.rand(2, 3, rng) * 4,
                touch = true
            }
            LockItemSprite(pickup, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, callbacks.BirthrightEffect)

function callbacks:OnCouponUse()
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == 5 then
            entity = entity:ToPickup()
            local ind = GetPickupInd(entity)
            if entity.Price == 0 and mod.Data.Teegro.lockedItems[ind] then
                mod.Data.Teegro.lockedItems[ind] = nil
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, callbacks.OnCouponUse, CollectibleType.OnCouponUse)
mod:AddCallback(ModCallbacks.MC_USE_CARD, callbacks.OnCouponUse, Card.CARD_CREDIT)

local GuppyEyeOffsets = {
	[1] = {Vector(0, 4)},
	[2] = {Vector(8, 4), Vector(-8, 4)},
	[3] = {Vector(0, 8), Vector(-12, 0), Vector(12, 0)},
	[4] = {Vector(0, 12), Vector(-12, 6), Vector(12, 6), Vector(0, 0)},
	[5] = {Vector(0, 16), Vector(-9, 9), Vector(9, 9), Vector(-6, 0), Vector(6, 0)},
	[6] = {Vector(-6, 16), Vector(6, 16), Vector(-9, 8), Vector(9, 8), Vector(-6, 0), Vector(6, 0)},
	[7] = {Vector(-6, 16), Vector(6, 16), Vector(-12, 8), Vector(0, 8), Vector(12, 8), Vector(-6, 0), Vector(6, 0)},
	[8] = {Vector(0, 16), Vector(9, 14), Vector(-9, 14), Vector(12, 8), Vector(-12, 8), Vector(9, 2), Vector(-9, 2), Vector(0,0)}
}
function callbacks:GuppysEyeFunctionality(pickup)
    if not mod.CharaterHasItem(CollectibleType.COLLECTIBLE_GUPPYS_EYE) or pickup.Variant ~= HunterChestVariant then return end
    if pickup:GetSprite():GetAnimation() == "Open" then return end
    local ind = GetPickupInd(pickup)
    local drop = mod.Data.Teegro.chestDrops[ind]
    if not drop then return end
    local spr = Sprite()
    spr.Color = Color(spr.Color.R, spr.Color.G, spr.Color.B, 0.6, spr.Color.RO, spr.Color.GO, spr.Color.BO)
    spr.Scale = Vector(0.5, 0.5)
    for i, dr in ipairs(drop) do
        local offset = Vector(0, -12)
        if dr.Variant == 100 then
            spr:Load("gfx/005.100_collectible.anm2", true)
            spr:SetFrame("Idle", 0)
            if Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND ~= 0 then
                spr:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png")
            else
                spr:ReplaceSpritesheet(1, Isaac.GetItemConfig():GetCollectible(dr.SubType).GfxFileName)
            end
            offset = offset + Vector(0, 12)
            spr:LoadGraphics()
        elseif dr.Variant == PickupVariant.PICKUP_TRINKET then
            spr:Load("gfx/005.350_trinket.anm2", true)
            spr:SetFrame("Idle", 0)
            spr:ReplaceSpritesheet(0, Isaac.GetItemConfig():GetTrinket(dr.SubType).GfxFileName)
            spr:LoadGraphics()
        else
            spr:Load("gfx/" .. dr.anm2 .. ".anm2", true)
            spr:SetFrame("Idle", 0)
            spr:LoadGraphics()
            if dr.Variant == PickupVariant.PICKUP_TAROTCARD then
                offset = offset + Vector(0, 4)
            end
        end
        spr:Render(Game():GetRoom():WorldToScreenPosition(pickup.Position) + offset + GuppyEyeOffsets[#drop][i] * 0.8)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_RENDER, callbacks.GuppysEyeFunctionality)

local function IsActionHold(action)
    for i = 0, Game():GetNumPlayers() - 1 do
        if Input.IsActionPressed(action, i) then
            return true
        end
    end
    return false
end

local f = Font()
f:Load("font/terminus.fnt")
local spr = Sprite()
spr:Load("gfx/ui/hunter_key.anm2", true)
spr:SetFrame("Idle", 0)
local tabHold = 0
function callbacks:RenderDreamBookCharges()
    local TeegroPosition = nil
    for i = 1, Game():GetNumPlayers() do
        if Isaac.GetPlayer(i - 1):GetPlayerType() == mod.PLAYER_TIGRO then
            TeegroPosition = Isaac.GetPlayer(i - 1).Position
        end
    end
    if TeegroPosition == nil or not mod.Data.Teegro then return end
    local room = Game():GetRoom()
    if IsActionHold(ButtonAction.ACTION_MAP) then
        tabHold = tabHold + 1
    else 
        tabHold = 0
    end
    if Game():GetHUD():IsVisible() then
        local alpha = 1
        if RenderSincePickup > 120 then
            alpha = 1 - (RenderSincePickup - 120) / 30
        end
        if tabHold >= 30 - 1 then
            tabHold = 30
            alpha = 1
            RenderSincePickup = 60
        end
        local coords1 = room:WorldToScreenPosition(TeegroPosition) - Vector(6, 40)
        local coords2 = Vector(coords1.X + 8, coords1.Y - 4)
        if room:IsMirrorWorld() then
            coords1.X = Isaac.GetScreenWidth() - coords1.X
            coords2.X = Isaac.GetScreenWidth() - coords2.X
        end
        spr:Render(coords1, Vector.Zero, Vector.Zero)
        spr:SetFrame("Idle", mod.Data.Teegro.keyShards % 4)
        spr.Color = Color(1, 1, 1, alpha)
        f:DrawStringScaled(mod.Data.Teegro.keyShards // 4, coords2.X, coords2.Y, 0.65, 0.65, KColor(1, 1, 1, alpha), 0, true)
    end
    RenderSincePickup = math.min(RenderSincePickup + 1, 180)
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, callbacks.RenderDreamBookCharges)