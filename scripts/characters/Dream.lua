local mod = InVerse
local callbacks = {}

mod.PLAYER_DREAM = Isaac.GetPlayerTypeByName("Dream")

mod.Characters[mod.PLAYER_DREAM] = {
    Hair = Isaac.GetCostumeIdByPath("gfx/characters/dreamshair.anm2"),
    DAMAGE = -0.4,
    DAMAGE_MULT = 1,
    FIREDELAY = 0.9,
    SPEED = -0.15,
    SHOTSPEED = 0.25,
    TEARHEIGHT = -2,
    TEARFALLINGSPEED = 0.2,
    LUCK = 0,
    FLYING = false,
    TEARFLAG = 0,
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
}

function callbacks:OnInit(player)
    if player:GetPlayerType() == mod.PLAYER_DREAM then
        player:AddNullCostume(mod.Characters[mod.PLAYER_DREAM].Hair)
        player:AddCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE)
        player:AddCollectible(mod.COLLECTIBLE_MOMENTUUM)
        Game():GetItemPool():RemoveCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.OnInit)

function callbacks:OnPlayerUpdate(player)
    local num = mod.GetPlayerNum(player)
    if mod.Data.Players[num].HaveBR ~= nil and not mod.Data.Players[num].HaveBR and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        mod.Data.Players[num].HaveBR = true
        if player:GetPlayerType() == mod.PLAYER_DREAM then
            player:SetPocketActiveItem(mod.COLLECTIBLE_MOMENTUUM, ActiveSlot.SLOT_POCKET, true)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, callbacks.OnPlayerUpdate)