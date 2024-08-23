local mod = InVerse
local callbacks = {}

mod.PLAYER_TIGRO = Isaac.GetPlayerTypeByName("Tigro")
local HunterKeyVariant = Isaac.GetEntityVariantByName("Hunter Key")
local HunterKeyPartVariant = Isaac.GetEntityVariantByName("Hunter Key Part")
local KeyPriceVariant = Isaac.GetEntityVariantByName("Key Price")
local RenderSincePickup = 0

function callbacks:SetDefaultValues(player) -- Set Defaul Values
    if not mod.Data.Tigro then
        mod.Data.Tigro = {
            checkedItems = {},
            lockedItems = {},
            keyShards = 0
        }
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.SetDefaultValues)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.SetDefaultValues)

mod.Characters[mod.PLAYER_TIGRO] = {
    Hair = Isaac.GetCostumeIdByPath("gfx/characters/tigro_hair.anm2"),
    Tail = Isaac.GetCostumeIdByPath("gfx/characters/tigro_tail.anm2"),
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
local function LockItemSprite(item)
    local ind = item.InitSeed
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
end

function callbacks:OnPickupInit(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local ind = pickup.InitSeed
    if pickup.Variant == 100 and not mod.Data.Tigro.checkedItems[ind] and pickup:GetSprite():GetAnimation() ~= "Empty" then
        mod.Data.Tigro.checkedItems[ind] = true
        local cost = 4
        if pickup.Price ~= 0 then
            if ({[-1] = true, [-6] = true, [-7] = true})[pickup.Price] then
                cost = 8
            elseif ({[-2] = true, [-3] = true, [-4] = true, [-8] = true, [-9] = true})[pickup.Price] then
                cost = 12
            end
            pickup.Price = 0
        end
        mod.Data.Tigro.lockedItems[ind] = {
            cost = cost
        }
        LockItemSprite(pickup)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.OnPickupInit)

function callbacks:LockPickupSpritesOnNewRoom()
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        local pickup = entity:ToPickup()
        if pickup then
            local ind = pickup.InitSeed
            if mod.Data.Tigro.lockedItems[ind] then
                LockItemSprite(pickup)
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.LockPickupSpritesOnNewRoom)

function callbacks:LockedItemInteraction(pickup, collider, low)
    if collider:ToPlayer() == nil then return end
    local ind = pickup.InitSeed
    if mod.Data.Tigro.lockedItems[ind] then
        local anim = pickup.Child:GetSprite():GetAnimation()
        if anim ~= "FrontUnlocking" and mod.Data.Tigro.keyShards >= mod.Data.Tigro.lockedItems[ind].cost then
            mod.Data.Tigro.keyShards = mod.Data.Tigro.keyShards - mod.Data.Tigro.lockedItems[ind].cost
            pickup.Child:GetSprite():Play("FrontUnlocking")
            pickup.Child.Child:GetSprite():Play("BackUnlocking")
            SFXManager():Play(SoundEffect.SOUND_CHAIN_BREAK)
        end
        return false
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.LockedItemInteraction)

function callbacks:UnlockItem(pickup)
    if not mod.CharaterInGame(mod.PLAYER_TIGRO) then return end
    local ind = pickup.InitSeed
    if pickup.Variant == 100 and mod.Data.Tigro.lockedItems[ind] and pickup.Child:GetSprite():IsFinished("FrontUnlocking") then
        mod.Data.Tigro.lockedItems[ind] = nil
        pickup.Child.Child:Remove()
        pickup.Child:Remove()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, callbacks.UnlockItem)

function callbacks:GrabHunterKey(pickup, collider, low)
    if collider:ToPlayer() == nil then return end
    if pickup.Variant == HunterKeyVariant or pickup.Variant == HunterKeyPartVariant then
        if pickup:GetSprite():IsPlaying("Collect") then return true end
        pickup:GetSprite():Play("Collect")
        mod.Data.Tigro.keyShards = mod.Data.Tigro.keyShards + mod._if(pickup.Variant == HunterKeyVariant, 4, 1)
        SFXManager():Play(
            mod._if(pickup.Variant == HunterKeyVariant or mod.Data.Tigro.keyShards % 4 == 0, SoundEffect.SOUND_DEATH_BURST_BONE, SoundEffect.SOUND_BONE_HEART)
        )
        RenderSincePickup = 0
        return true
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.GrabHunterKey)

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
    local TigroPosition = nil
    for i = 1, Game():GetNumPlayers() do
        if Isaac.GetPlayer(i - 1):GetPlayerType() == mod.PLAYER_TIGRO then
            TigroPosition = Isaac.GetPlayer(i - 1).Position
        end
    end
    if TigroPosition == nil or not mod.Data.Tigro then return end
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
        local coords = Isaac.WorldToRenderPosition(TigroPosition) - Vector(0, 40)
        spr:Render(coords - Vector(6, 0), Vector.Zero, Vector.Zero)
        spr:SetFrame("Idle", mod.Data.Tigro.keyShards % 4)
        spr.Color = Color(1, 1, 1, alpha)
        f:DrawStringScaled(mod.Data.Tigro.keyShards // 4, coords.X + 2, coords.Y - 4, 0.65, 0.65, KColor(1, 1, 1, alpha), 0, true)
    end
    RenderSincePickup = math.min(RenderSincePickup + 1, 180)
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, callbacks.RenderDreamBookCharges)



mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    -- print(Game():GetRoom():GetAwardSeed(), pickup.DropSeed)
end)