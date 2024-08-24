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
            itemsDeleteOnNewRoom = {}
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
    else
        item.Price = 0
        item.SpriteOffset = Vector(0, 14)
        item:GetSprite():SetFrame("Idle", 0)
        item:GetSprite():RemoveOverlay()
        local effect = Isaac.Spawn(1000, KeyPriceVariant, 0, item.Position + Vector(0, 10), Vector.Zero, nil):ToEffect()
        effect.DepthOffset = -10
        effect:GetSprite():SetFrame("Idle", mod.Data.Teegro.lockedItems[ind].cost // 4 - 1)
        item.Child = effect
    end
end

function callbacks:OnPickupInit(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local ind = GetPickupInd(pickup)
    if pickup.Variant == 100 and not mod.Data.Teegro.checkedItems[ind] and pickup:GetSprite():GetAnimation() ~= "Empty" then
        mod.Data.Teegro.checkedItems[ind] = true
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

local needReplace = {}
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
            print(pickup2:GetSprite():GetOverlayAnimation())
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
    if not pickup:GetSprite():IsPlaying("Appear") or pickup:GetSprite():GetFrame() ~= 1 then return end
    if pickup.Variant ~= 30 then return end
    local r = mod.rand(1, 1000)
    if r <= 5 then
        pickup:Morph(5, HunterKeyVariant, 0, true, false, true)
    elseif r <= 250 + 5 then
        pickup:Morph(5, HunterKeyPartVariant, 0, true, false, true)
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
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.DeleteItemOnNewRoom)

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



mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    -- print(Game():GetRoom():GetAwardSeed(), pickup.DropSeed)
end)