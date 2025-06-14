local mod = InVerse

if Poglite then
    Poglite:AddPogCostume("DreamPog", mod.PLAYER_DREAM, Isaac.GetCostumeIdByPath("gfx/characters/dreampog.anm2"))
    Poglite:AddPogCostume("DreamBSoulPog", mod.PLAYER_DREAMBSOUL, Isaac.GetCostumeIdByPath("gfx/characters/dreambsoulpog.anm2"))
    Poglite:AddPogCostume("DreamBBodyPog", mod.PLAYER_DREAMBBODY, Isaac.GetCostumeIdByPath("gfx/characters/dreambbodypog.anm2"), mod.Characters[mod.PLAYER_DREAMBBODY].Hair)
    Poglite:AddPogCostume("TeegroPog", mod.PLAYER_TEEGRO, Isaac.GetCostumeIdByPath("gfx/characters/teegropog.anm2"), mod.Characters[mod.PLAYER_TEEGRO].Hair)
end