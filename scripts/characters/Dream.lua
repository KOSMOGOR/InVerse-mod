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
    TEARRANGE = -2,
    LUCK = 0,
    FLYING = false,
    TEARFLAG = 0,
    TEARCOLOR = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0),
    GetBR = function(player)
        player:SetPocketActiveItem(mod.COLLECTIBLE_MOMENTUUM, ActiveSlot.SLOT_POCKET, true)
    end
}

function callbacks:OnInit(player)
    if player:GetPlayerType() == mod.PLAYER_DREAM then
        player:AddNullCostume(mod.Characters[mod.PLAYER_DREAM].Hair)
        player:AddCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE)
        player:AddCollectible(mod.COLLECTIBLE_MOMENTUUM)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, callbacks.OnInit)

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if not isContinued then
        Game():GetItemPool():RemoveCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE)
    end
end)