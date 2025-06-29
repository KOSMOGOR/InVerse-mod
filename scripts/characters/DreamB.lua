local mod = InVerse
local callbacks = {}

mod.PLAYER_DREAMBSOUL = Isaac.GetPlayerTypeByName('DreamBSoul', true)
mod.PLAYER_DREAMBBODY = Isaac.GetPlayerTypeByName('DreamBBody', true)
mod.COLLECTIBLE_PILFER = Isaac.GetItemIdByName('Pilfer')
mod.COLLECTIBLE_FILPER = Isaac.GetItemIdByName('Filper')
mod.SOUND_PILFER_AURA = Isaac.GetSoundIdByName('PilferAura')
mod.SOUND_PILFER_METKA = Isaac.GetSoundIdByName('PilferMetka')

local pilfer = {
    Active = {},
    MetkaVariant = Isaac.GetEntityVariantByName('Metka'),
    AuraVariant = Isaac.GetEntityVariantByName('PilferAura'),
    Aura = {},
    Aura2 = {},
    lastRoom = nil
}

local corpse = {}
local markedEnemies = {}
local heartsMelting = {}
local BRFamiliar = {}
local PlayerUsedPilfer = nil
function callbacks:SetDefaultValues(player)
    local num = mod.GetPlayerNum(player)
    if not markedEnemies[num] then markedEnemies[num] = {} end
    if not heartsMelting[num] then heartsMelting[num] = 0 end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.SetDefaultValues)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.SetDefaultValues)

mod.Characters[mod.PLAYER_DREAMBSOUL] = {
    Hair = Isaac.GetCostumeIdByPath('gfx/characters/t_dre_ghost_hair.anm2'),
    DAMAGE = 0,
    DAMAGE_MULT = 1.2,
    FIREDELAY = 1.1,
    SPEED = 0,
    SHOTSPEED = 0.25,
    TEARRANGE = -80,
    LUCK = 0,
    FLYING = true,
    TEARFLAG = TearFlags.TEAR_SPECTRAL,
    TEARCOLOR = Color(187 / 255 * 1.5, 227 / 255 * 1.5, 251 / 255 * 1.5, 0.6, 0, 0, 0)
}
mod.Characters[mod.PLAYER_DREAMBBODY] = {
    Hair = Isaac.GetCostumeIdByPath('gfx/characters/t_dre_hair.anm2'),
    DAMAGE = 0,
    DAMAGE_MULT = 0.8,
    FIREDELAY = 0.9,
    SPEED = 0,
    SHOTSPEED = 0.25,
    TEARHEIGHT = -2,
    TEARFALLINGSPEED = 0.2,
    LUCK = 0,
    FLYING = false,
    TEARFLAG = 0,
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
}

function callbacks:OnInit(player)
    if player:IsCoopGhost() then return end
    if player:GetPlayerType() == mod.PLAYER_DREAMBSOUL then
        --player:GetSprite():Load('gfx/characters/dreamb_soul.anm2')
        player:GetSprite():Load('gfx/001.000_player.anm2')
        for i = 0, 14 do
            player:GetSprite():ReplaceSpritesheet(i, 'gfx/characters/costumes/t_dre_ghost.png')
        end
        player:GetSprite():ReplaceSpritesheet(13, 'gfx/characters/costumes/t_dream_ded.png')
        player:GetSprite():LoadGraphics()
        player:AddNullCostume(mod.Characters[mod.PLAYER_DREAMBSOUL].Hair)
        player:RemoveCostume(Isaac.GetItemConfig():GetNullItem(mod.Characters[mod.PLAYER_DREAMBBODY].Hair))
        for i = 0, 3 do
            if player:GetActiveItem(i) == mod.COLLECTIBLE_PILFER then
                player:DischargeActiveItem(i)
                break
            end
        end
    elseif player:GetPlayerType() == mod.PLAYER_DREAMBBODY then
        player:ChangePlayerType(mod.PLAYER_DREAMBBODY)
        player:GetSprite():Load('gfx/001.000_player.anm2')
        for i = 0, 14 do
            player:GetSprite():ReplaceSpritesheet(i, 'gfx/characters/costumes/t_dre.png')
        end
        player:GetSprite():ReplaceSpritesheet(13, 'gfx/characters/costumes/t_dream_ded.png')
        player:GetSprite():LoadGraphics()
        player:AddNullCostume(mod.Characters[mod.PLAYER_DREAMBBODY].Hair)
        player:RemoveCostume(Isaac.GetItemConfig():GetNullItem(mod.Characters[mod.PLAYER_DREAMBSOUL].Hair))
        for i = 0, 3 do
            if player:GetActiveItem(i) == mod.COLLECTIBLE_PILFER then
                player:DischargeActiveItem(i)
                break
            end
        end
        player:AnimateSad()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.OnInit)

local function MeltingHeartsTime(hearts)
    return 2 * (2.71828)^(-hearts / 6 + 3) + 1
end

function callbacks:OnPlayerUpdate(player)
    local num = mod.GetPlayerNum(player)
    if player:GetPlayerType() == mod.PLAYER_DREAMBSOUL and not player:HasCollectible(mod.COLLECTIBLE_PILFER) then
        player:SetPocketActiveItem(mod.COLLECTIBLE_PILFER)
    elseif player:GetPlayerType() == mod.PLAYER_DREAMBBODY and not player:HasCollectible(mod.COLLECTIBLE_FILPER) then
        player:SetPocketActiveItem(mod.COLLECTIBLE_FILPER)
    end
    if player:GetPlayerType() == mod.PLAYER_DREAMBSOUL or player:GetPlayerType() == mod.PLAYER_DREAMBBODY then
        local HeartContainers = player:GetMaxHearts()
        if HeartContainers > 0 then
            player:AddMaxHearts(-HeartContainers)
            player:AddSoulHearts(HeartContainers)
        end
        local BoneHearts = player:GetBoneHearts()
        if BoneHearts > 0 then
            player:AddBoneHearts(-BoneHearts)
            player:AddSoulHearts(BoneHearts)
        end
    end
    if player:GetPlayerType() == mod.PLAYER_DREAMBBODY then
        heartsMelting[num] = heartsMelting[num] + 1
        local heartsAdd = mod._if(player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT), 2, 0)
        local remain = MeltingHeartsTime(player:GetSoulHearts() + heartsAdd) * 60 - heartsMelting[num]
        if player:GetSoulHearts() == 1 then
            SFXManager():Play(SoundEffect.SOUND_ISAACDIES)
            player:ChangePlayerType(mod.PLAYER_DREAMBSOUL)
            callbacks:OnInit(player)
            local ent = Isaac.Spawn(1000, EffectVariant.DEVIL, 0, player.Position, Vector.Zero, nil)
            ent:GetSprite():Load('gfx/001.000_player.anm2')
            for i = 0, 12 do
                ent:GetSprite():ReplaceSpritesheet(i, 'gfx/characters/costumes/t_dre.png')
            end
            --ent:GetSprite():ReplaceSpritesheet(13, '')
            ent:GetSprite():LoadGraphics()
            ent:GetSprite():Play('DeathTeleport', true)
            if corpse[num] and corpse[num]:Exists() then
                corpse[num]:Remove()
            end
            corpse[num] = ent
        elseif remain <= 90 then
            if remain <= 35 and math.floor(remain) % 7 == 0 then
                local color = Color(0.7, 0, 0, 1, 0.8, 0, 0)
                player:SetColor(color, 2, 1, false, false)
            else
                local c = 0.3 + (remain / 90) * 0.55
                local color = Color(1, c, c, 1, (1 - c) * 0.1, 0, 0)
                player:SetColor(color, 2, 2, false, false)
            end
            if remain <= 0 then
                player:TakeDamage(1, DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), 0)
                heartsMelting[num] = 0
            end
        end
    elseif player:GetPlayerType() == mod.PLAYER_DREAMBSOUL then
        if player:GetSoulHearts() > 1 then
            player:ChangePlayerType(mod.PLAYER_DREAMBBODY)
            if corpse[num] and corpse[num]:Exists() then
                corpse[num]:Remove()
            end
            callbacks:OnInit(player)
        end
        heartsMelting[num] = 0
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.OnPlayerUpdate, 0)

function callbacks:OnGameStart(IsContinued)
    for i = 1, 8 do
        markedEnemies[i] = {}
        heartsMelting[i] = mod._if(IsContinued, heartsMelting[i], 0)
        pilfer.Active[i] = nil
    end
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if not IsContinued and player:GetPlayerType() == mod.PLAYER_DREAMBSOUL then
            player:FullCharge(2)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, callbacks.OnGameStart)

function callbacks:OnUsePilfer(_type, RNG, player)
    local num = mod.GetPlayerNum(player)
    if pilfer.Active[num] then
        return false
    end
    local soulFactor = math.min(7 * player:GetSoulHearts(), 84)
    local stageFactor = math.min(6 * (Game():GetLevel():GetAbsoluteStage() - 1), 60)
    local rand = mod.rand(1, 100, RNG) <= soulFactor + stageFactor
    if player:HasCollectible(mod.COLLECTIBLE_PILFER) or not rand then
        pilfer.Active[num] = Game():GetFrameCount()
        if pilfer.Aura[num] then
            pilfer.Aura[num]:Remove()
        end
        pilfer.Aura[num] = Isaac.Spawn(1000, pilfer.AuraVariant, 0, player.Position - Vector(0, 20), Vector.Zero, player):ToEffect()
        pilfer.Aura[num]:FollowParent(player)
        pilfer.Aura[num].SpriteScale = Vector(1, 1) * mod._if(player:HasCollectible(mod.COLLECTIBLE_PILFER), 1, 0.65)
        if BRFamiliar[num] and BRFamiliar[num]:Exists() then
            if pilfer.Aura2[num] then
                pilfer.Aura2[num]:Remove()
            end
            pilfer.Aura2[num] = Isaac.Spawn(1000, pilfer.AuraVariant, 0, BRFamiliar[num].Position - Vector(0, 20), Vector.Zero, BRFamiliar[num]):ToEffect()
            pilfer.Aura2[num]:FollowParent(BRFamiliar[num])
            pilfer.Aura2[num].SpriteScale = Vector(0.75, 0.75)
        end
        SFXManager():Play(mod.SOUND_PILFER_AURA)
    else
        local dmg = 40 --(player:GetSoulHearts() - 1) * player.Damage / 4
        player:AddSoulHearts(-player:GetSoulHearts() + 1)
        local entities = Game():GetRoom():GetEntities()
        for i = 0, #entities - 1 do
            local entity = entities:Get(i)
            if entity:IsVulnerableEnemy() then
                PlayerUsedPilfer = num
                entity:TakeDamage(dmg, 0, EntityRef(player), 0)
                local angle = mod.rand(1, 360, RNG)
                local x = math.cos(math.rad(angle))
                local y = math.sin(math.rad(angle))
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, entity.Position, Vector(2 * x, 2 * y), nil):ToPickup()
                pickup.Timeout = 45
            end
        end
        SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
        local ent = Isaac.Spawn(1000, 16, 1, player.Position, Vector.Zero, player)
        ent:GetSprite().Color = Color(0.22, 0.17, 0.32)
        Game():ShakeScreen(15)
    end
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, callbacks.OnUsePilfer, mod.COLLECTIBLE_PILFER)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, callbacks.OnUsePilfer, mod.COLLECTIBLE_FILPER)

function callbacks:OnPilferUpdate(player)
    local num = mod.GetPlayerNum(player)
    local entities = Isaac.GetRoomEntities()
    if pilfer.Active[num] then
        local dis = mod._if(player:HasCollectible(mod.COLLECTIBLE_PILFER), 80, 60)
        for i = 1, #entities do
            local ent = entities[i]
            if (ent.Position:Distance(player.Position) <= dis or BRFamiliar[num] and ent.Position:Distance(BRFamiliar[num].Position) <= dis * 0.75) and
            ent:IsVulnerableEnemy() and not markedEnemies[num][ent.Index] then
                markedEnemies[num][ent.Index] = {
                    entity = ent,
                    metka = Isaac.Spawn(1000, pilfer.MetkaVariant, 0, ent.Position + Vector(0, -60), Vector.Zero, player):ToEffect()
                }
                markedEnemies[num][ent.Index].metka:FollowParent(ent)
                markedEnemies[num][ent.Index].metka.DepthOffset = 100
                SFXManager():Play(mod.SOUND_PILFER_METKA)
            end
        end
        for ind, i in pairs(markedEnemies[num]) do
            if i.entity:IsDead() then
                i.metka:Remove()
                markedEnemies[num][ind] = nil
            end
        end
        if Game():GetFrameCount() - pilfer.Active[num] >= mod._if(player:HasCollectible(mod.COLLECTIBLE_PILFER), 90, 60) or 
            Game():GetFrameCount() - pilfer.Active[num] >= 10 and player:GetActiveItem(2) == mod.COLLECTIBLE_PILFER and Input.IsActionPressed(ButtonAction.ACTION_PILLCARD, player.ControllerIndex) then
            local doSnd = false
            pilfer.Active[num] = false
            for _, i in pairs(markedEnemies[num]) do
                if not i.entity:IsDead() then
                    i.entity:TakeDamage(player.Damage * 2, 0, EntityRef(player), 0)
                    if not player:IsDead() then
                        player:AddSoulHearts(1)
                    end
                    doSnd = true
                end
                i.metka:Remove()
            end
            SFXManager():Stop(mod.SOUND_PILFER_AURA)
            if doSnd then
                SFXManager():Play(SoundEffect.SOUND_TOOTH_AND_NAIL)
            end
            markedEnemies[num] = {}
            pilfer.Aura[num]:Remove()
            if pilfer.Aura2[num] then
                pilfer.Aura2[num]:Remove()
            end
        end
    end
    if PlayerUsedPilfer then
        PlayerUsedPilfer = nil
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.OnPilferUpdate)

function callbacks:OnNewRoom()
    local entities = Isaac.GetRoomEntities()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == mod.PLAYER_DREAMBSOUL then
            for j = 1, #entities do
                if entities[j].Type == 1000 and entities[j].Variant == EffectVariant.BLOOD_SPLAT then
                    entities[j]:Remove()
                    break
                end
            end
        end
    end
    for i = 1, 8 do
        markedEnemies[i] = {}
        if pilfer.Active[i] then
            SFXManager():Stop(mod.SOUND_PILFER_AURA)
        end
        pilfer.Active[i] = nil
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, callbacks.OnNewRoom)

function callbacks:FreeDevilDeals(pickup, player)
    player = player:ToPlayer()
    if player and player:GetPlayerType() == mod.PLAYER_DREAMBSOUL and pickup.Price >= -9 and pickup.Price <= -1 then
        pickup.Price = 0
        local entities = Isaac.GetRoomEntities()
        for i = 1, #entities do
            local ent = entities[i]:ToPickup()
            if ent and ent.Price >= -9 and ent.Price <= -1 then
                ent:Remove()
                Isaac.Spawn(1000, EffectVariant.POOF01, 0, ent.Position, Vector.Zero, nil)
            end
        end
        Game():AddDevilRoomDeal()
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, callbacks.FreeDevilDeals)

function callbacks:CheckBRFamiliar(player)
    local num = mod.GetPlayerNum(player)
    if player:GetPlayerType() == mod.PLAYER_DREAMBSOUL or player:GetPlayerType() == mod.PLAYER_DREAMBBODY then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and (not BRFamiliar[num] or not BRFamiliar[num]:Exists()) and player:GetPlayerType() == mod.PLAYER_DREAMBSOUL then
            local pos
            if corpse[num] and corpse[num]:Exists() then
                corpse[num]:Remove()
                pos = corpse[num].Position
            else
                pos = player.Position
            end
            BRFamiliar[num] = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.CUBE_OF_MEAT_4, 0, pos, Vector.Zero, player)
            BRFamiliar[num]:GetSprite():ReplaceSpritesheet(0, "gfx/familiar/t_dre_br_body.png")
            BRFamiliar[num]:GetSprite():ReplaceSpritesheet(1, "gfx/familiar/t_dre_br_head.png")
            BRFamiliar[num]:GetSprite():LoadGraphics()
        elseif (not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) or player:GetPlayerType() == mod.PLAYER_DREAMBBODY) and BRFamiliar[num] and BRFamiliar[num]:Exists() then
            BRFamiliar[num]:Remove()
            BRFamiliar[num] = nil
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.CheckBRFamiliar)

function callbacks:OnTakeDmg(entity, damageAmount, damageFlags, damageSource, damageCountdownFrames)
    if entity:IsVulnerableEnemy() and --[[entity:HasMortalDamage()]]entity.HitPoints - damageAmount <= 0 and PlayerUsedPilfer then
        --Isaac.GetPlayer(PlayerUsedPilfer):AddSoulHearts(2)
    end
end
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, callbacks.OnTakeDmg)