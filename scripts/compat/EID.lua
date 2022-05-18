local mod = InVerse

local MomentuumCardDesc = {
    en = {
        [Card.CARD_FOOL] = "Uses {{Collectible419}}. Has 60% chance to spawn in random room#Can spawn even in the locked/undiscovered room",
        [Card.CARD_MAGICIAN] = "Gives homing shots. Has 40% chance to break at the start of each floor",
        [Card.CARD_HIGH_PRIESTESS] = "Every second Mom stomps at random enemy#When the room is clear she will start to stomp on you on you instead",
        [Card.CARD_EMPRESS] = "If you have 1/2 of a heart gives you {{Collectible360}} and {{Collectible698}}#At the start of new floor leaves you with only half a heart. Empties even soul and black hearts#Doesn't work on Keeper",
        [Card.CARD_EMPEROR] = "Reveals the Boss room#After beating the boss gives 2 items. You can take only one#If it possible, guaranteed deal will occur with effect of {{Collectible498}}",
        [Card.CARD_HIEROPHANT] = "If the room has more than 3 enemies the card will transform them into soul hearts#Otherwise gives you 3 soul hearts",
        [Card.CARD_LOVERS] = "Converts all your soul and black hearts simillar to {{Collectible296}}#Fully heals you#If you have 0 red heart containers gives 3 soul hearts instead",
        [Card.CARD_CHARIOT] = "To the end of the floor gives {{Collectible172}}#Uses {{Collectible298}} in every uncleared room",
        [Card.CARD_JUSTICE] = "All your coins, keys and bombs are equal to the maximum of the values",
        [Card.CARD_HERMIT] = "Раскрывает и открывает магазин #При заходе в магазин рероллит предметы с эффектом {{Collectible402}}",
        [Card.CARD_WHEEL_OF_FORTUNE] = "Gives {{Collectible489}}#Has 20% chance to break on use",
        [Card.CARD_STRENGTH] = "Gives within the room:#↑ +2 Health Ups#↑ +100% Damage",
        [Card.CARD_HANGED_MAN] = "Gives flight, spectral tears and the effect of {{Trinket151}} for the floor",
        [Card.CARD_DEATH] = "Summons a friendly Death boss#The boss is gradually dying",
        [Card.CARD_TEMPERANCE] = "Gives {{Collectible135}} and gulped {{panic button}}#If you remove the Bag, it breaks giving you 2-20 melting halves of hearts#The panic button disappears in this case too",
        [Card.CARD_DEVIL] = "In each uncleared room gives the {{Collectible34}} effect#Has a 20% chance of breaking on taking damage ",
        [Card.CARD_TOWER] = "Gives {{Collectible375}}#A bomb is placed every half a second#The bomb has a 5% chance of being replaced by a special one",
        [Card.CARD_STARS] = "Teleports to treasure room#The item is rerolled with the effects of {{Collectible689}} and {{Collectible691}}",
        [Card.CARD_MOON] = "Gives the active item The Moon ( {{Моментуум-Луна}} )#Teleports through all the secret rooms#The order is: Secret > Super Secret > Ultra Secret Room#After teleporting to the ultra secret room the item breaks",
        [Card.CARD_SUN] = "If there is 1/2 red health or less left when taking damage, uses the \"Sun\" card and gives a broken heart#Has 40% of breaking when activated",
        [Card.CARD_JUDGEMENT] = "Spawns all kinds of beggars",
        [Card.CARD_WORLD] = "Gives the effects of {{Collectible333}}, {{Collectible76}} and {{highlighting stone}} for the floor"
    },
    ru = {
        [Card.CARD_FOOL] = "Использует {{Collectible419}}. Шанс 60% появиться в случайной комнате#Может появиться даже в запертой/неисследованной комнате",
        [Card.CARD_MAGICIAN] = "Даёт самонаводящиеся слёзы. Имеет шанс 40% сломаться в начале нового этажа",
        [Card.CARD_HIGH_PRIESTESS] = "Каждую секунду Мама наступает на случайного врага#Когда в комнате никого не останется, вместо этого она начнёт топтать тебя",
        [Card.CARD_EMPRESS] = "Если у тебя половина сердечка, то даёт {{Collectible360}} и {{Collectible698}}#В начале нового этажа опустошает тебя до половины сердечка. Работает даже на сердца души и чёрные сердца#Не работает на Хранителе",
        [Card.CARD_EMPEROR] = "Открывает комнату Босса#После победы над боссом даёт два предмета на выбор#Если возможно, будет гарантированная сделка с эффект {{Collectible498}}",
        [Card.CARD_HIEROPHANT] = "Если в комнате больше, чем 3 врага, карта превратит их в сердца души#Иначе даёт тебе 3 сердца души",
        [Card.CARD_LOVERS] = "Конвертирует все твои сердца души и чёрные сердца на подобии {{Collectible296}}#Полностью тебя лечит#Если у тебя 0 красных контейнеров, вместо этого даёт 3 сердца души",
        [Card.CARD_CHARIOT] = "Да конца этажа даёт {{Collectible172}}#В каждой незачищенной комнате использует {{Collectible298}}",
        [Card.CARD_JUSTICE] = "Все ваши монеты, ключи и бомбы равны максимальному из значений",
        [Card.CARD_HERMIT] = "Reveals and opens the shop#When entering the shop rerolls items with {{Collectible402}} effect",
        [Card.CARD_WHEEL_OF_FORTUNE] = "Даёт {{Collectible489}}#Есть шанс 20% сломаться при использовании",
        [Card.CARD_STRENGTH] = "Даёт в пределах комнаты:#↑ +2 к здоровью#↑ +100% урона",
        [Card.CARD_HANGED_MAN] = "Даёт на этаж полёт, спектральные слёзы и эффект {{Trinket151}}",
        [Card.CARD_DEATH] = "Призывает дружественного босса Смерть#Босс постепенно умирает",
        [Card.CARD_TEMPERANCE] = "Даёт {{Collectible135}} и проглоченную {{кнопку паники}}#Если убрать капельницу, то она ломается и даёт 2-20 исчезающих половинок сердец#Кнопка паники в таком случае исчезает тоже",
        [Card.CARD_DEVIL] = "В каждой незачщиненной комнате даёт эффект {{Collectible34}}#При получении урона имеет 20% шанс сломаться",
        [Card.CARD_TOWER] = "Даёт {{Collectible375}}#Каждые пол секунды ставится бомба#У бомбы есть шанс 5% замениться на особую",
        [Card.CARD_STARS] = "Телепортирует в сокровищницу#Предмет рероллится с эффектами {{Collectible689}} и {{Collectible691}}",
        [Card.CARD_MOON] = "Даёт активный предмет Луна ( {{Моментуум-Луна}} )#Телепортирует по всем секретным комнатам#Порядок: Секретная > Супер секретная > Ультра секретная комната#После телепорта в ультра секретную комнату предмет ломается",
        [Card.CARD_SUN] = "Если при получении урона осталось 1/2 красного здоровья или меньше, использует карту \"Солнце\" и даёт разбитое сердце#При активации имеет 40% шанс сломаться",
        [Card.CARD_JUDGEMENT] = "Создаёт все виды попрошаек",
        [Card.CARD_WORLD] = "Даёт на этаж эффекты {{Collectible333}}, {{Collectible76}} и {{подсвечивающего камня}}"
    }
}
local MomCardTarotDesc = {
    en = {
        [Card.CARD_FOOL] = "Uses {{Collectible419}}. Has {{ColorGold}}80%{{CR}} chance to spawn in random room#Can spawn even in the locked/undiscovered room",
        [Card.CARD_HIGH_PRIESTESS] = "Every {{ColorGold}}0.5{{CR}} second Mom stomps at random enemy#When the room is clear she will start to stomp on you on you instead",
        [Card.CARD_EMPEROR] = MomentuumCardDesc.en[Card.CARD_EMPEROR] .. "#{{Collectible451}} Gives you {{Collectible588}} effect for the floor",
        [Card.CARD_HIEROPHANT] = MomentuumCardDesc.en[Card.CARD_HIEROPHANT] .. "#{{Collectible451}} ↑+2 soul hearts",
        [Card.CARD_LOVERS] = MomentuumCardDesc.en[Card.CARD_LOVERS] .. "#{{Collectible451}} Gives 1 soul heart before converting",
        [Card.CARD_CHARIOT] = "To the end of the floor gives {{ColorGold}}2{{CR}} {{Collectible172}}#Uses {{Collectible298}} in every uncleared room",
        [Card.CARD_JUSTICE] = "All your coins, keys, bombs {{ColorGold}}and health{{CR}} are equal to the maximum of the values",
        [Card.CARD_WHEEL_OF_FORTUNE] = MomentuumCardDesc.en[Card.CARD_WHEEL_OF_FORTUNE] .. "#{{Collectible451}} The item is charged twice",
        [Card.CARD_STRENGTH] = "Gives within the room:#↑ {{ColorGold}}+3{{CR}} Health Ups#↑ {{ColorGold}}+150%{{CR}} Damage",
        [Card.CARD_HANGED_MAN] = "Gives flight, spectral {{ColorGold}}piercing{{CR}} tears and the effect of {{Trinket151}} for the floor",
        [Card.CARD_DEATH] = "Summons {{ColorGold}}2{{CR}} friendly Death bosses#The bosses is gradually dying",
        [Card.CARD_TOWER] = "Gives {{Collectible375}}#A bomb is placed every half a second#The bomb has a {{ColorGold}}20%{{CR}} chance of being replaced by a special one",
        [Card.CARD_STARS] = MomentuumCardDesc.en[Card.CARD_STARS] .. "#{{Collectible451}} The effect of {{Collectible414}} is also given",
        [Card.CARD_JUDGEMENT] = "Fills the room with beggars",
        [Card.CARD_WORLD] = MomentuumCardDesc.en[Card.CARD_WORLD] .. "#{{Collectible451}} Also gives the effect of {{Collectible260}}"
    },
    ru = {
        [Card.CARD_FOOL] = "Использует {{Collectible419}}. Шанс {{ColorGold}}80%{{CR}} появиться в случайной комнате#Может появиться даже в запертой/неисследованной комнате",
        [Card.CARD_HIGH_PRIESTESS] = "Каждые {{ColorGold}}полсекунды{{CR}} Мама наступает на случайного врага#Когда в комнате никого не останется, вместо этого она начнёт топтать тебя",
        [Card.CARD_EMPEROR] = MomentuumCardDesc.ru[Card.CARD_EMPEROR] .. "#{{Collectible451}} Даёт эффект {{Collectible588}} на весь этаж",
        [Card.CARD_HIEROPHANT] = MomentuumCardDesc.ru[Card.CARD_HIEROPHANT] .. "#{{Collectible451}} ↑+2 сердца души",
        [Card.CARD_LOVERS] = MomentuumCardDesc.ru[Card.CARD_LOVERS] .. "#{{Collectible451}} Перед конвертацией даёт 1 сердце души",
        [Card.CARD_CHARIOT] = "Да конца этажа даёт {{ColorGold}}2{{CR}} {{Collectible172}}#В каждой незачищенной комнате использует {{Collectible298}}",
        [Card.CARD_JUSTICE] = "Все ваши монеты, ключи, бомбы {{ColorGold}}и здоровье{{CR}} равны максимальному из значений",
        [Card.CARD_WHEEL_OF_FORTUNE] = MomentuumCardDesc.en[Card.CARD_WHEEL_OF_FORTUNE] .. "#{{Collectible451}} Предмет заряжен дважды",
        [Card.CARD_STRENGTH] = "Даёт в пределах комнаты:#↑ {{ColorGold}}+3{{CR}} к здоровью#↑ {{ColorGold}}+150%{{CR}} урона",
        [Card.CARD_HANGED_MAN] = "Даёт на этаж полёт, спектральные {{ColorGold}}пронзающие{{CR}} слёзы и эффект {{Trinket151}}",
        [Card.CARD_DEATH] = "Призывает {{ColorGold}}2{{CR}} дружественных боссов Смерть#Боссы постепенно умирает",
        [Card.CARD_TOWER] = "Даёт {{Collectible375}}#Каждые пол секунды ставится бомба#У бомбы есть шанс {{ColorGold}}20%{{CR}} замениться на особую",
        [Card.CARD_STARS] = MomentuumCardDesc.ru[Card.CARD_STARS] .. "#{{Collectible451}} Также даётся эффект {{Collectible414}}",
        [Card.CARD_JUDGEMENT] = "Заполняет комнату случайными попрошайками",
        [Card.CARD_WORLD] = MomentuumCardDesc.en[Card.CARD_WORLD] .. "#{{Collectible451}} Также даёт эффект {{Collectible260}}"
    }
}
local MomTrinketMomsBoxDesc = {
    en = {
        [Card.CARD_MAGICIAN] = "Gives homing shots. Has {{ColorGold}}20%{{CR}} chance to break at the start of each floorS",
        [Card.CARD_EMPRESS] = "{{ColorGold}}Always{{CR}} gives you {{Collectible360}} and {{Collectible698}}#At the start of new floor leaves you with only half a heart. Empties even soul and black hearts#Doesn't work on Keeper",
        [Card.CARD_HERMIT] = MomentuumCardDesc.en[Card.CARD_HERMIT] .. "#{{Collectible439}} If there's a card selling in the shop rerolls it into random opened Momentuum Card",
        [Card.CARD_DEVIL] = "In each uncleared room gives the {{Collectible34}} effect#Has a {{ColorGold}}10%{{CR}} chance of breaking on taking damage ",
        [Card.CARD_SUN] = "If there is 1/2 red health or less left when taking damage, uses the \"Sun\" card and gives a broken heart#Has {{ColorGold}}20%{{CR}} of breaking when activated"
    },
    ru = {
        [Card.CARD_MAGICIAN] = "Даёт самонаводящиеся слёзы. Имеет шанс {{ColorGold}}20%{{CR}} сломаться в начале нового этажа",
        [Card.CARD_EMPRESS] = "{{ColorGold}}Всегда{{CR}} даёт {{Collectible360}} и {{Collectible698}}#В начале нового этажа опустошает тебя до половины сердечка. Работает даже на сердца души и чёрные сердца#Не работает на Хранителе",
        [Card.CARD_HERMIT] = MomentuumCardDesc.en[Card.CARD_HERMIT] .. "#{{Collectible439}} Если в магазине продаётся карта, то рероллит её на случайную открытую Моментуум Карту",
        [Card.CARD_DEVIL] = "В каждой незачщиненной комнате даёт эффект {{Collectible34}}#При получении урона имеет {{ColorGold}}10%{{CR}} шанс сломаться",
        [Card.CARD_SUN] = "Если при получении урона осталось 1/2 красного здоровья или меньше, использует карту \"Солнце\" и даёт разбитое сердце#При активации имеет {{ColorGold}}20%{{CR}} шанс сломаться"
    }
}
local MomentuumMoonDesc = {
    en = "Gives the active item The Moon ( {{Моментуум-Луна}} )#Teleports through all the secret rooms#The order is: Secret > Super Secret > Ultra Secret Room#After teleporting to the ultra secret room the item breaks",
    ru = "Даёт активный предмет Луна ( {{Моментуум-Луна}} )#Телепортирует по всем секретным комнатам#Порядок: Секретная > Супер секретная > Ультра секретная комната#После телепорта в ультра секретную комнату предмет ломается"
}
local MomToCard = {
    [Isaac.GetCardIdByName("mom_fool")] = Card.CARD_FOOL,
    [Isaac.GetCardIdByName("mom_priestess")] = Card.CARD_HIGH_PRIESTESS,
    [Isaac.GetCardIdByName("mom_emperor")] = Card.CARD_EMPEROR,
    [Isaac.GetCardIdByName("mom_hierophant")] = Card.CARD_HIEROPHANT,
    [Isaac.GetCardIdByName("mom_lovers")] = Card.CARD_LOVERS,
    [Isaac.GetCardIdByName("mom_chariot")] = Card.CARD_CHARIOT,
    [Isaac.GetCardIdByName("mom_justice")] = Card.CARD_JUSTICE,
    [Isaac.GetCardIdByName("mom_strength")] = Card.CARD_STRENGTH,
    [Isaac.GetCardIdByName("mom_hanged")] = Card.CARD_HANGED_MAN,
    [Isaac.GetCardIdByName("mom_death")] = Card.CARD_DEATH,
    [Isaac.GetCardIdByName("mom_tower")] = Card.CARD_TOWER,
    [Isaac.GetCardIdByName("mom_stars")] = Card.CARD_STARS,
    [Isaac.GetCardIdByName("mom_judgement")] = Card.CARD_JUDGEMENT,
    [Isaac.GetCardIdByName("mom_world")] = Card.CARD_WORLD
}

function HasMomentuum(descObj)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(mod.COLLECTIBLE_MOMENTUUM) then
            return true
        end
    end
end
function IsDreamExists(descObj)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:GetPlayerType() == mod.PLAYER_DREAM then
            return true
        end
    end
end
function IsMomentuumTrinket(descObj)
    return HasMomentuum(descObj) and descObj.ObjType == 5 and descObj.ObjVariant == 350 and ({
        [mod.TRINKET_DEVIL] = true,
        [mod.TRINKET_EMPRESS] = true,
        [mod.TRINKET_HERMIT] = true,
        [mod.TRINKET_MAGICIAN] = true,
        [mod.TRINKET_SUN] = true
    })[descObj.ObjSubType]
end
function IsMomentuumCard(descObj)
    return Isaac.GetCardIdByName("mom_fool") <= descObj.ObjSubType and descObj.ObjSubType <= Isaac.GetCardIdByName("mom_world")
end
function IsCardCanBeMomentued(descObj)
    return HasMomentuum(descObj) and descObj.ObjType == 5 and descObj.ObjVariant == 300 and (MomentuumCardDesc.en[descObj.ObjSubType] or MomentuumCardDesc.en[descObj.ObjSubType - 55])
end
function AddMomentuumCardDescCallback(descObj)
    local desc1 = mod._if(EID:getLanguage() == "ru", MomentuumCardDesc.ru[descObj.ObjSubType], MomentuumCardDesc.en[descObj.ObjSubType])
    local desc2 = mod._if(EID:getLanguage() == "ru", MomentuumCardDesc.ru[descObj.ObjSubType - 55], MomentuumCardDesc.en[descObj.ObjSubType - 55])
    local desc = desc1 or desc2
    local tarotDesc = GetMomCardTarotDesc(descObj)
    local momsBoxDesc = mod._if(EID:getLanguage() == "ru", MomTrinketMomsBoxDesc.ru[descObj.ObjSubType], MomTrinketMomsBoxDesc.en[descObj.ObjSubType])
    if EID.collectiblesOwned[CollectibleType.COLLECTIBLE_TAROT_CLOTH] and CardHasTarotDesc(descObj) then
        desc = tarotDesc
    elseif EID.collectiblesOwned[CollectibleType.COLLECTIBLE_MOMS_BOX] and MomTrinketMomsBoxDesc.en[descObj.ObjSubType] then
        desc = momsBoxDesc
    end
    EID:appendToDescription(descObj, "#{{Blank}}#{{Momentuum}} " .. desc)
    --descObj.Description = "#{{Momentuum}} " .. desc
    return descObj
end
function CardHasTarotDesc(descObj)
    return MomCardTarotDesc.en[descObj.ObjSubType] or MomCardTarotDesc.en[MomToCard[descObj.ObjSubType]] or MomCardTarotDesc.en[descObj.ObjSubType - 55]
end
function HasTarotClothAndMomCard(descObj)
    return EID.collectiblesOwned[CollectibleType.COLLECTIBLE_TAROT_CLOTH] and IsMomentuumCard(descObj) and CardHasTarotDesc(descObj)
end
function GetMomCardTarotDesc(descObj)
    local desc1 = mod._if(EID:getLanguage() == "ru", MomCardTarotDesc.ru[descObj.ObjSubType], MomCardTarotDesc.en[descObj.ObjSubType])
    local desc2 = mod._if(EID:getLanguage() == "ru", MomCardTarotDesc.ru[MomToCard[descObj.ObjSubType]], MomCardTarotDesc.en[MomToCard[descObj.ObjSubType]])
    local desc3 = mod._if(EID:getLanguage() == "ru", MomCardTarotDesc.ru[descObj.ObjSubType - 55], MomCardTarotDesc.en[descObj.ObjSubType - 55])
    local desc = desc1 or desc2 or desc3
    return desc
end
function AddDreamGlitchedDeckCallback(descObj)
    local desc = mod._if(EID:getLanguage() == "ru", "Если предмет держит Дрим, то увеличивает вероятность спавна Моментуум Карт", "If held by Dream increaces the chance of Momentuum Card spawning")
    EID:appendToDescription(descObj, "#{{DreamIcon}} " .. desc)
    return descObj
end
function ChangeMomCardTarotDescCallback(descObj)
    local desc = mod._if(EID:getLanguage() == "ru", MomCardTarotDesc.ru[MomToCard[descObj.ObjSubType]], MomCardTarotDesc.en[MomToCard[descObj.ObjSubType]])
    descObj.Description = desc
    return descObj
end
function IsMomTrinketAndMomsBox(descObj)
    return (IsMomentuumTrinket(descObj) or IsMomentuumTrinket(descObj)) and EID.collectiblesOwned[CollectibleType.COLLECTIBLE_MOMS_BOX]
end
function ChangeMomTrinketMomsBoxDescCallback(descObj)
    local desc = mod._if(EID:getLanguage() == "ru", MomTrinketMomsBoxDesc.ru[MomToCard[descObj.ObjSubType]], MomTrinketMomsBoxDesc.en[MomToCard[descObj.ObjSubType]])
    descObj.Description = desc
    return descObj
end

if EID then
    local icon = Sprite()
    icon:Load("gfx/ui/EID_icons.anm2", true)
    EID:addIcon("Momentuum", "Momentuum", 0, 8, 8, 4.5, 5.5, icon)
    EID:addIcon("DreamIcon", "DreamIcon", 0, 8, 8, 4.5, 5.5, icon)
    EID:addIcon("MomentuumMoon", "MomentuumMoon", 0, 8, 8, 4.5, 5.5, icon)

    EID:addBirthright(mod.PLAYER_DREAM, "Gives {{Momentuum}} as a pocket item.")
    EID:addBirthright(mod.PLAYER_DREAM, "Даёт {{Momentuum}} в качестве карманного предмета.", "Дрим", "ru")

    EID:addCollectible(mod.COLLECTIBLE_MOMENTUUM, "Throw it somewhere lol#Or hold with a card for funni#{{Blank}}#{{Warning}} Description isn't implemented yet")
    EID:addCollectible(mod.COLLECTIBLE_MOMENTUUM, "Кинь куда-нибудь лол#Или зажми с картой для прикола#{{Blank}}#{{Warning}} Описание ещё не добавлено", "Моментуум", "ru")
    EID:addCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE, "Gives charges every time you enter a special room#The number of charges you get depends on room type#When used spends charges and heals you#When held down for 2 seconds converts 3 charges to half a soul heart")
    EID:addCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_ACTIVE, "Даёт заряды каждый раз, когда ты входишь в особую комнату#Количество зарядов, которые ты получишь, зависит от типа комнаты#При использовании тратит заряды и лечит тебя#При удерживании на 2 секунды конвертирует 3 заряда в половину сердца души", "Сонник", "ru")
    EID:addCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE, "Gives charges every time you enter a special room#The number of charges you get depends on room type#Tries to automatically spend charges depending on the situation")
    EID:addCollectible(mod.COLLECTIBLE_DREAMS_DREAM_BOOK_PASSIVE, "Даёт заряды каждый раз, когда ты входишь в особую комнату#Количество зарядов, которые ты получишь, зависит от типа комнаты#Старается автоматически тратить заряды в зависимости от ситуации", "Сонник", "ru")
    EID:addCollectible(mod.COLLECTIBLE_GLITCHED_DECK, "Momentuum Cards can spawn naturally#Only unlocked Momentuum Cards can spawn")
    EID:addCollectible(mod.COLLECTIBLE_GLITCHED_DECK, "Моментуум Карты могут появиться естественным образом#Только открытые Моментуум Карты могут появиться", "Глюкнутая колода", "ru")
    EID:addCollectible(mod.COLLECTIBLE_MOON, MomentuumMoonDesc.en)
    EID:addCollectible(mod.COLLECTIBLE_MOON, MomentuumMoonDesc.ru, "Моментуум-Луна", "ru")

    EID:addDescriptionModifier("MomentuumCardDesc", IsCardCanBeMomentued, AddMomentuumCardDescCallback)
    EID:addDescriptionModifier("MomCardTarotDesc", HasTarotClothAndMomCard, ChangeMomCardTarotDescCallback)
    EID:addDescriptionModifier("DreamGlitchedDeck", function(descObj) return descObj.fullItemString == "5.100." .. mod.COLLECTIBLE_GLITCHED_DECK and IsDreamExists(descObj) end, AddDreamGlitchedDeckCallback)
    EID:addDescriptionModifier("MomTrinketMomsBoxDesc", IsMomTrinketAndMomsBox, ChangeMomTrinketMomsBoxDescCallback)
    EID:addDescriptionModifier("AddMoonCarBatteryDesc", function (descObj)
        return descObj.fullItemString == "5.100." .. mod.COLLECTIBLE_MOON or descObj.fullItemString == "5.300." .. Card.CARD_MOON and EID.collectiblesOwned[CollectibleType.COLLECTIBLE_CAR_BATTERY]
    end, function(descObj)
        local desc = mod._if(EID:getLanguage() == "ru", "Перед поломкой можно активировать ещё 1 раз для телепорта в комнату \"Я - Ошибка\"", "Before the breaking you can activate it 1 more time to teleport to the \"I am a Error\" room")
        EID:appendToDescription(descObj, "#{{Collectible356}} " .. desc)
        return descObj
    end)

    EID:addCard(Isaac.GetCardIdByName("mom_fool"), MomentuumCardDesc.en[Card.CARD_FOOL])
    EID:addCard(Isaac.GetCardIdByName("mom_fool"), MomentuumCardDesc.ru[Card.CARD_FOOL], "Моментуум: 0 - Дурак", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_priestess"), MomentuumCardDesc.en[Card.CARD_HIGH_PRIESTESS])
    EID:addCard(Isaac.GetCardIdByName("mom_priestess"), MomentuumCardDesc.ru[Card.CARD_HIGH_PRIESTESS], "Моментуум: II - Верховная жрица", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_emperor"), MomentuumCardDesc.en[Card.CARD_EMPEROR])
    EID:addCard(Isaac.GetCardIdByName("mom_emperor"), MomentuumCardDesc.ru[Card.CARD_EMPEROR], "Моментуум: IV - Император", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_hierophant"), MomentuumCardDesc.en[Card.CARD_HIEROPHANT])
    EID:addCard(Isaac.GetCardIdByName("mom_hierophant"), MomentuumCardDesc.ru[Card.CARD_HIEROPHANT], "Моментуум: V - Иерофант", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_lovers"), MomentuumCardDesc.en[Card.CARD_LOVERS])
    EID:addCard(Isaac.GetCardIdByName("mom_lovers"), MomentuumCardDesc.ru[Card.CARD_LOVERS], "Моментуум: VI - Влюблённые", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_chariot"), MomentuumCardDesc.en[Card.CARD_CHARIOT])
    EID:addCard(Isaac.GetCardIdByName("mom_chariot"), MomentuumCardDesc.ru[Card.CARD_CHARIOT], "Моментуум: VII - Колесница", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_justice"), MomentuumCardDesc.en[Card.CARD_JUSTICE])
    EID:addCard(Isaac.GetCardIdByName("mom_justice"), MomentuumCardDesc.ru[Card.CARD_JUSTICE], "Моментуум: VIII - Правосудие", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_wheel"), MomentuumCardDesc.en[Card.CARD_WHEEL_OF_FORTUNE])
    EID:addCard(Isaac.GetCardIdByName("mom_wheel"), MomentuumCardDesc.ru[Card.CARD_WHEEL_OF_FORTUNE], "Моментуум: X - Колесо фортуны", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_strength"), MomentuumCardDesc.en[Card.CARD_STRENGTH])
    EID:addCard(Isaac.GetCardIdByName("mom_strength"), MomentuumCardDesc.ru[Card.CARD_STRENGTH], "Моментуум: XI - Сила", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_hanged"), MomentuumCardDesc.en[Card.CARD_HANGED_MAN])
    EID:addCard(Isaac.GetCardIdByName("mom_hanged"), MomentuumCardDesc.ru[Card.CARD_HANGED_MAN], "Моментуум: XII - Повешанный", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_death"), MomentuumCardDesc.en[Card.CARD_DEATH])
    EID:addCard(Isaac.GetCardIdByName("mom_death"), MomentuumCardDesc.ru[Card.CARD_DEATH], "Моментуум: XIII - Смерть", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_temperance"), MomentuumCardDesc.en[Card.CARD_TEMPERANCE])
    EID:addCard(Isaac.GetCardIdByName("mom_temperance"), MomentuumCardDesc.ru[Card.CARD_TEMPERANCE], "Моментуум: XIV - Умеренность", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_tower"), MomentuumCardDesc.en[Card.CARD_TOWER])
    EID:addCard(Isaac.GetCardIdByName("mom_tower"), MomentuumCardDesc.ru[Card.CARD_TOWER], "Моментуум: XVI - Башня", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_stars"), MomentuumCardDesc.en[Card.CARD_STARS])
    EID:addCard(Isaac.GetCardIdByName("mom_stars"), MomentuumCardDesc.ru[Card.CARD_STARS], "Моментуум: XVII - Звёзды", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_moon"), MomentuumCardDesc.en[Card.CARD_MOON])
    EID:addCard(Isaac.GetCardIdByName("mom_moon"), MomentuumCardDesc.ru[Card.CARD_MOON], "Моментуум: XVIII - Луна", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_judgement"), MomentuumCardDesc.en[Card.CARD_JUDGEMENT])
    EID:addCard(Isaac.GetCardIdByName("mom_judgement"), MomentuumCardDesc.ru[Card.CARD_JUDGEMENT], "Моментуум: XX - Суд", "ru")
    EID:addCard(Isaac.GetCardIdByName("mom_world"), MomentuumCardDesc.en[Card.CARD_WORLD])
    EID:addCard(Isaac.GetCardIdByName("mom_world"), MomentuumCardDesc.ru[Card.CARD_WORLD], "Моментуум: XXI - Мир", "ru")
end