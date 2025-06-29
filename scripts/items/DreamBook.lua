local mod = InVerse
local callbacks = {}

mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE = Isaac.GetItemIdByName("Dream's Dream Book (passive)")
mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE = Isaac.GetItemIdByName("Dream's Dream Book")

local chargeBars = {}
local holdingTimer = {}
local lastFrameHolded = {}
local pause = {}
local needHold = 60 * 2
local needHeal = {}
local needHealBlue = {}
function callbacks:SDVDreamBook(player) -- Set Defaul Values
    local num = mod.GetPlayerNum(player)
    if not mod.Data.DreamBookCharges then mod.Data.DreamBookCharges = {} end
    if not mod.Data.DreamBookCharges[num] then mod.Data.DreamBookCharges[num] = 0 end
    if holdingTimer[num] == nil then holdingTimer[num] = 0 end
    if pause[num] == nil then pause[num] = 0 end
    if chargeBars[num] == nil then
        chargeBars[num] = Sprite()
        chargeBars[num]:Load("gfx/chargebar.anm2", true)
        chargeBars[num].PlaybackSpeed = 0.5
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.SDVDreamBook)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.SDVDreamBook)

function callbacks:AddDreamBookCharges()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local num = mod.GetPlayerNum(player)
        if player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE) or player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE) then
            if Game():GetRoom():IsFirstVisit() then
                local roomTypeTable = {
                    [2] = 1, [3] = 4, [4] = 1, [7] = 2, [8] = 2, [9] = 1, [10] = 1, [12] = 2, [14] = 2, [15] = 3,
                    [17] = 3, [18] = 2, [19] = 2, [20] = 3, [21] = 3, [22] = 4, [24] = 3, [27] = 1, [29] = 4
                }
                if roomTypeTable[Game():GetRoom():GetType()] then
                    mod.Data.DreamBookCharges[num] = math.min(99, mod.Data.DreamBookCharges[num] + roomTypeTable[Game():GetRoom():GetType()] * mod._if(player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE) and player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY), 2, 1))
                    player:AnimateCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE, "Pickup", "PlayerPickupSparkle")
                    break
                end
                if Game():GetRoom():GetType() == 11 then
                    mod.Data.DreamBookCharges[num] = math.min(99, mod.Data.DreamBookCharges[num] + mod._if(Game():GetLevel():HasBossChallenge(), 2, 1) * mod._if(player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE) and player:HasCollectible(CollectibleType.COLLECTIBLE_CAR_BATTERY), 2, 1))
                end
            end
        else
            mod.Data.DreamBookCharges[num] = 0
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.AddDreamBookCharges)

function callbacks:DreamBookUse(_type, RNG, player)
    local num = mod.GetPlayerNum(player)
    if --[[pause[num] == 0 and]] holdingTimer[num] == 0 then
        holdingTimer[num] = 1
        lastFrameHolded[num] = true
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, callbacks.DreamBookUse, mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE)

local function HealPlayer(player, heal)
    local num = mod.GetPlayerNum(player)
    if not player:CanPickRedHearts() then
        return
    end
    local canBeHealed = player:GetEffectiveMaxHearts() - player:GetHearts()
    heal = math.min(heal or canBeHealed, canBeHealed, mod.Data.DreamBookCharges[num])
    if heal ~= 0 then
        player:AddHearts(heal)
        mod.Data.DreamBookCharges[num] = mod.Data.DreamBookCharges[num] - heal
        local ent = Isaac.Spawn(1000, EffectVariant.HEART, 0, player.Position - Vector(0, 60), Vector.Zero, player):ToEffect()
        ent:FollowParent(player)
        SFXManager():Play(SoundEffect.SOUND_BOSS2_BUBBLES)
        return true
    end
end
local function HealPlayerSoul(player)
    local num = mod.GetPlayerNum(player)
    if mod.Data.DreamBookCharges[num] >= 3 then
        player:AddSoulHearts(1)
        mod.Data.DreamBookCharges[num] = mod.Data.DreamBookCharges[num] - 3
        local ent = Isaac.Spawn(1000, EffectVariant.HEART, 0, player.Position - Vector(0, 60), Vector.Zero, player):ToEffect()
        ent:FollowParent(player)
        SFXManager():Play(SoundEffect.SOUND_HOLY)
    end
end

function callbacks:DreamBookHolding(player)
    local num = mod.GetPlayerNum(player)
    if --[[pause[num] == 0 and]] holdingTimer[num] >= 1 and player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE) and Input.IsActionPressed(ButtonAction.ACTION_ITEM, player.ControllerIndex) then
        if lastFrameHolded[num] then
            holdingTimer[num] = holdingTimer[num] + 1
        else
            lastFrameHolded[num] = true
            holdingTimer[num] = 0
        end
    elseif not Input.IsActionPressed(ButtonAction.ACTION_ITEM, player.ControllerIndex) then
        if 0 < holdingTimer[num] and holdingTimer[num] <= 10 then
            if HealPlayer(player) then
                player:AnimateCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE, "Pickup", "PlayerPickupSparkle")
            end
        end
        holdingTimer[num] = 0
        lastFrameHolded[num] = false
    end
    if holdingTimer[num] == needHold then
        if mod.Data.DreamBookCharges[num] >= 3 then
            HealPlayerSoul(player)
            player:AnimateCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE, "Pickup", "PlayerPickupSparkle")
        end
        holdingTimer[num] = 0
        --pause[num] = 30
    end
    --[[if pause[num] ~= 0 then
        pause[num] = pause[num] - 1
    end]]
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.DreamBookHolding)

function callbacks:DreamBookConsumeChargesOnDamage(player, damageAmount, damageFlags, damageSource, damageCountdownFrames)
    player = player:ToPlayer()
    local num = mod.GetPlayerNum(player)
    if player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE) then
        --[[if player:GetSoulHearts() == 0 then
            HealPlayer(player, 1)
        elseif mod.Data.DreamBookCharges[num] >= 3 then
            HealPlayerSoul(player)
        end]]
        if player:GetHearts() == player:GetEffectiveMaxHearts() and player:GetSoulHearts() - damageAmount <= 1 and damageFlags & DamageFlag.DAMAGE_RED_HEARTS == 0 and mod.Data.DreamBookCharges[num] >= 3 then
            needHealBlue[num] = true
        elseif player:GetHearts() < player:GetEffectiveMaxHearts() and player:GetSoulHearts() == 0 and player:GetHearts() - damageAmount <= 2 then
            HealPlayer(player)
            needHeal[num] = true
        end
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, callbacks.DreamBookConsumeChargesOnDamage, EntityType.ENTITY_PLAYER)

function callbacks:DreamBookConsumeChargesOnUpdate(player)
    player = player:ToPlayer()
    local num = mod.GetPlayerNum(player)
    if player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE) then
        if needHeal[num] then
            HealPlayer(player)
            needHeal[num] = nil
        elseif needHealBlue[num] then
            if mod.Data.DreamBookCharges[num] >= 3 then
                HealPlayerSoul(player)
            end
            needHealBlue[num] = nil
        elseif player:GetHearts() < player:GetEffectiveMaxHearts() and player:GetSoulHearts() >= 1 and mod.Data.DreamBookCharges[num] >= 4 then
            HealPlayer(player, mod.Data.DreamBookCharges[num] - 3)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.DreamBookConsumeChargesOnUpdate)

function callbacks:RenderChargeBar(player, offset)
    local num = mod.GetPlayerNum(player)
    if not holdingTimer[num] then return end
    if holdingTimer[num] > 10 and holdingTimer[num] < needHold then
        local perc = math.floor(100.0 * holdingTimer[num] / needHold)
        if perc < 99 then
            chargeBars[num]:SetFrame("Charging", perc)
        end
    elseif lastFrameHolded[num] and holdingTimer[num] == 0 and not chargeBars[num]:IsPlaying("Disappear") and not chargeBars[num]:IsFinished("Disappear") then
        chargeBars[num]:Play("Disappear", true)
    end
    chargeBars[num]:Render(Isaac.WorldToRenderPosition(player.Position) + Vector(20, -30) + offset, Vector.Zero, Vector.Zero)
    chargeBars[num]:Update()
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, callbacks.RenderChargeBar)

local f = Font()
f:Load("font/terminus.fnt")
local spr = Sprite()
spr:Load("gfx/ui/DreamBook_Render.anm2", true)
spr:Play("Idle")
function callbacks:RenderDreamBookCharges()
    if not mod.Data.DreamBookCharges then return end
    local y = 0
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        local num = mod.GetPlayerNum(player)
        if (player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE) or player:HasCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE)) and Game():GetHUD():IsVisible() then
            spr:Render(Vector(45 + 20 * Options.HUDOffset, 35 + 12 * Options.HUDOffset + y), Vector.Zero, Vector.Zero)
            f:DrawStringScaled("x" .. (mod.Data.DreamBookCharges[num] or 0), 55 + 20 * Options.HUDOffset, 30 + 12 * Options.HUDOffset + y, 0.7, 0.7, KColor(1, 1, 1, 1), 0, true)
            f:DrawStringScaled(i + 1, 47 + 20 * Options.HUDOffset, 33 + 12 * Options.HUDOffset + y, 0.5, 0.5, KColor(1, 1, 1, 1), 0, true)
            y = y + 15
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, callbacks.RenderDreamBookCharges)