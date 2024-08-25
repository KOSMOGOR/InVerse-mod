local mod = InVerse
local callbacks = {}

mod.PLAYER_TIGRO = Isaac.GetPlayerTypeByName("Teegro")
local HunterKeyVariant = Isaac.GetEntityVariantByName("Hunter Key")
local HunterKeyPartVariant = Isaac.GetEntityVariantByName("Hunter Key Part")
local KeyPriceVariant = Isaac.GetEntityVariantByName("Key Price")
local HunterChestVariant = Isaac.GetEntityVariantByName("Hunter Chest")
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
            lastRoomCleared = true,
            bossInRoom = false
        }
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.SetDefaultValues)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.SetDefaultValues)

local function SelectRandomWeights(table, RNG)
    local sum = 0
    for i = 1, #table do
        sum = sum + table[i][1]
    end
    local n = mod.rand(1, sum, RNG)
    sum = 0
    for i = 1, #table do
        sum = sum + table[i][1]
        if n <= sum then
            return table[i][2]
        end
    end
end

local function GetRandomItem(minimumQuality, pools)
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
    local item = items[mod.rand(1, #items)]
    itemPool:RemoveCollectible(item)
    return item
end

local function GetMomCards()
    local cards = {}
    local itemConfig = Isaac.GetItemConfig()
    for i = 1, #itemConfig:GetCards() do
        local el = itemConfig:GetCard(i)
        if el and mod.Data.GlobalData.CardsCanSpawn[el.HudAnim] then
            table.insert(cards, el.ID)
        end
    end
    return cards
end

local function GetPickupInd(pickup)
    return tostring(pickup.InitSeed)
end

mod.Characters[mod.PLAYER_TIGRO] = {
    Hair = Isaac.GetCostumeIdByPath("gfx/characters/teegro_hair.anm2"),
    Tail = Isaac.GetCostumeIdByPath("gfx/characters/teegro_tail.anm2"),
    DAMAGE = 0.7,
    DAMAGE_MULT = 1,
    FIREDELAY = 0.9,
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
        item.Price = 0
        item.SpriteOffset = Vector(0, 14)
        item:GetSprite():SetFrame("Idle", 0)
        item:GetSprite():RemoveOverlay()
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
        elseif effect.Position.X ~= effect.Parent.Position.X then
            effect.Position = Vector(effect.Parent.Position.X, effect.Position.Y)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, callbacks.UpdateChainsAndPrice)

function callbacks:OnPickupInit(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local ind = GetPickupInd(pickup)
    if mod.Data.Teegro.lockedItems[ind] and not pickup.Child then
        LockItemSprite(pickup, mod.Data.Teegro.lockedItems[ind].touch)
    end
    if pickup.Variant == 100 and not mod.Data.Teegro.checkedItems[ind] and pickup:GetSprite():GetAnimation() ~= "Empty" then
        mod.Data.Teegro.checkedItems[ind] = true
        if Isaac.GetItemConfig():GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST) then return end
        local cost = 4
        local touch = false
        if pickup.Price ~= 0 then
            if ({[-2] = true, [-3] = true, [-4] = true, [-8] = true, [-9] = true, [30] = true})[pickup.Price] then
                cost = 12
                touch = true
            elseif ({[-1] = true, [-7] = true, [15] = true})[pickup.Price] then
                cost = 8
                touch = true
            elseif pickup.Price == -6 or pickup.Price > 0 then
                cost = 4
                touch = true
            end
            pickup.Price = 0
        end
        mod.Data.Teegro.lockedItems[ind] = {
            cost = cost,
            touch = touch
        }
        LockItemSprite(pickup, touch)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.OnPickupInit)

function callbacks:LockedItemInteraction(pickup, collider, low)
    if collider:ToPlayer() == nil or pickup:GetSprite():GetAnimation() == "Empty" then return end
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
            end
        end
        return mod.Data.Teegro.lockedItems[ind].touch
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
    if pickup.Variant == HunterKeyVariant or pickup.Variant == HunterKeyPartVariant then
        if pickup:GetSprite():IsPlaying("Collect") then return true end
        pickup:GetSprite():Play("Collect")
        mod.Data.Teegro.keyShards = mod.Data.Teegro.keyShards + mod._if(pickup.Variant == HunterKeyVariant, 4, 1)
        SFXManager():Play(
            mod._if(pickup.Variant == HunterKeyVariant or mod.Data.Teegro.keyShards % 4 == 0, SoundEffect.SOUND_DEATH_BURST_BONE, SoundEffect.SOUND_BONE_HEART)
        )
        RenderSincePickup = 0
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.GrabHunterKey)

function callbacks:OpenHunterChest(pickup, collider, low)
    local rng = RNG()
    rng:SetSeed(pickup.InitSeed, 35)
    if collider:ToPlayer() == nil then return end
    if pickup.Variant == HunterChestVariant and pickup:GetSprite():GetAnimation() == "Idle" and mod.Data.Teegro.keyShards >= 4 then
        mod.Data.Teegro.keyShards = mod.Data.Teegro.keyShards - 4
        local spawnPickups = {}
        local playAnim = true
        local rand = mod.rand(1, 6, rng)
        local momCards = GetMomCards()
        if rand == 5 and #momCards == 0 then rand = 4 end
        if rand == 1 then
            local rand2 = mod.rand(1, 3)
            local rand3 = mod.rand(3, 7)
            if rand2 == 1 then
                table.insert(spawnPickups, {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN})
            elseif rand2 == 2 then
                table.insert(spawnPickups, {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN})
            else
                local tt = Game():GetItemPool():GetTrinket()
                Game():GetItemPool():RemoveTrinket(tt)
                table.insert(spawnPickups, {PickupVariant.PICKUP_TRINKET, tt | TrinketType.TRINKET_GOLDEN_FLAG})
            end
            for _ = 1, rand3 do
                local coinSubType = SelectRandomWeights({
                    {9263, CoinSubType.COIN_PENNY},
                    {468, CoinSubType.COIN_NICKEL},
                    {100, CoinSubType.COIN_DIME},
                    {94, CoinSubType.COIN_LUCKYPENNY},
                    {25, CoinSubType.COIN_STICKYNICKEL},
                    {50, CoinSubType.COIN_GOLDEN},
                })
                table.insert(spawnPickups, {PickupVariant.PICKUP_COIN, coinSubType})
            end
        elseif rand == 2 or rand == 3 then
            local pos = pickup.Position
            local item = GetRandomItem(mod._if(rand == 2, 0, 2), mod._if(rand == 2, nil, {ItemPoolType.POOL_TREASURE}))
            local pickup2 = Isaac.Spawn(5, 100, item, pos, Vector.Zero, nil)
            pickup2:GetSprite():ReplaceSpritesheet(5, "gfx/teegro/Hunter_Chest_item.png")
            pickup2:GetSprite():LoadGraphics()
            pickup2:GetSprite():SetOverlayFrame("Alternates", 10)
            local ind = GetPickupInd(pickup2)
            mod.Data.Teegro.checkedItems[ind] = true
            playAnim = false
        elseif rand == 4 then
            for _ = 1, 3 do
                local card = mod.rand(56, 77)
                table.insert(spawnPickups, {PickupVariant.PICKUP_TAROTCARD, card})
            end
        elseif rand == 5 then
            local card = mod.rand(56, 77)
            table.insert(spawnPickups, {PickupVariant.PICKUP_TAROTCARD, card})
            local momCard = momCards[mod.rand(1, #momCards)]
            table.insert(spawnPickups, {PickupVariant.PICKUP_TAROTCARD, momCard})
        elseif rand == 6 then
            local rand2 = mod.rand(1, 7)
            for _ = 1, rand2 do
                table.insert(spawnPickups, {HunterKeyPartVariant, 0})
            end
        end
        for _, pickup1 in ipairs(spawnPickups) do
            local angle = math.rad(mod.rand(0, 359))
            local vec = Vector(math.cos(angle), math.sin(angle)) * 3
            Isaac.Spawn(5, pickup1[1], pickup1[2], pickup.Position, vec, nil)
        end
        SFXManager():Play(SoundEffect.SOUND_CHEST_OPEN)
        if playAnim then
            pickup:GetSprite():Play("Open")
            mod.Data.Teegro.itemsDeleteOnNewRoom[GetPickupInd(pickup)] = true
        else
            pickup:Remove()
        end
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.OpenHunterChest)

function callbacks:HunterKeyUpdate(pickup)
    if pickup.Variant == HunterKeyVariant or pickup.Variant == HunterKeyPartVariant then
        if pickup:GetSprite():IsPlaying("Collect") and pickup:GetSprite():GetFrame() >= 5 then
            pickup:Remove()
        elseif pickup:GetSprite():IsEventTriggered("DropSound") then
            SFXManager():Play(SoundEffect.SOUND_BONE_DROP)
        elseif pickup.Variant == HunterKeyPartVariant and pickup:GetSprite():IsPlaying("Appear") and pickup:GetSprite():GetFrame() == 1 then
            pickup:GetSprite():ReplaceSpritesheet(0, "gfx/items/pickups/pickup_hunter_key_part_" .. mod.rand(1, 4) .. ".png")
            pickup:GetSprite():LoadGraphics()
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
        local r = mod.rand(1, 1000, rng)
        if r <= 5 then
            pickup:Morph(5, HunterKeyVariant, 0, false, true)
        elseif r <= 250 + 5 then
            pickup:Morph(5, HunterKeyPartVariant, 0, false, true)
        end
    elseif pickup.Price ~= 0 then
        local r = mod.rand(1, 100, rng)
        if r <= 2 then
            pickup:Morph(5, HunterKeyVariant, 0, false, true)
            pickup.AutoUpdatePrice = false
            pickup.Price = 15
        elseif r <= 25 + 2 then
            pickup:Morph(5, HunterKeyPartVariant, 0, false, true)
            pickup.AutoUpdatePrice = false
            pickup.Price = 5
        end
    end
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

local function CheckBossInRoom()
    local entities = Game():GetRoom():GetEntities()
    for i = 0, #entities do
        local ent = entities:Get(i):ToNPC()
        if ent and ent:IsBoss() then
            mod.Data.Teegro.bossInRoom = true
            return
        end
    end
end
function callbacks:CheckRoomReward()
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local room = Game():GetRoom()
    local entities = room:GetEntities()
    if not room:IsClear() then CheckBossInRoom() end
    if not mod.Data.Teegro.lastRoomCleared and room:IsClear() then
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
            if r <= 47 + 5 then
                Isaac.Spawn(5, mod._if(r <= 5, HunterChestVariant, HunterKeyPartVariant), 0,
                    room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0), Vector.Zero, nil
                )
            end
        end
        if mod.Data.Teegro.bossInRoom and ({
            [RoomType.ROOM_BOSS] = true,
            [RoomType.ROOM_DEVIL] = true,
            [RoomType.ROOM_ANGEL] = true
        })[Game():GetRoom():GetType()] then
            Isaac.Spawn(5, HunterKeyVariant, 0,
                room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0), Vector.Zero, nil
            )
        end
    end
    mod.Data.Teegro.lastRoomCleared = room:IsClear()
    if room:IsClear() then mod.Data.Teegro.bossInRoom = false end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, callbacks.CheckRoomReward)

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

function callbacks:BirthrightEffect()
    local stage = Game():GetLevel():GetStage()
    if mod.CharaterHasBirthright(mod.PLAYER_TIGRO) and stage ~= LevelStage.STAGE6 then
        local rng = RNG()
        rng:SetSeed(Game():GetRoom():GetAwardSeed(), 35)
        for i = 1, 4 do
            local pos = Vector(200 + mod._if(i % 2 == 0, 240, 0), 200 + mod._if(i > 2, 160, 0))
            local item = GetRandomItem(0)
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
        local coords = Game():GetRoom():WorldToScreenPosition(TeegroPosition) - Vector(0, 40)
        spr:Render(coords - Vector(6, 0), Vector.Zero, Vector.Zero)
        spr:SetFrame("Idle", mod.Data.Teegro.keyShards % 4)
        spr.Color = Color(1, 1, 1, alpha)
        f:DrawStringScaled(mod.Data.Teegro.keyShards // 4, coords.X + 2, coords.Y - 4, 0.65, 0.65, KColor(1, 1, 1, alpha), 0, true)
    end
    RenderSincePickup = math.min(RenderSincePickup + 1, 180)
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, callbacks.RenderDreamBookCharges)