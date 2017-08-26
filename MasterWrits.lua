local DolgubonDebugRunningDebugString = ""
DolgubonGlobalDebugToggle = false
local localDebugToggle = false
function DolgubonGlobalDebugOutput(...)
	if GetDisplayName()=="@Dolgubon" and (DolgubonGlobalDebugToggle or localDebugToggle) then
		d(...)
	else
		local t = {...}
		for i = 1, #t do
			local str = t[i]
			str = tostring(str)
			DolgubonDebugRunningDebugString = DolgubonDebugRunningDebugString.."\n"..str
			if string.len(DolgubonDebugRunningDebugString)>2100 then
				DolgubonDebugRunningDebugString = string.sub(DolgubonDebugRunningDebugString, string.len(DolgubonDebugRunningDebugString)-2099)
			end
		end
	end
end


local function sendDebug()
	d("Sending mails")
	local len = string.len(DolgubonDebugRunningDebugString)
	local t = {}
	if len<700 then
		RequestOpenMailbox()
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT", DolgubonDebugRunningDebugString)end , 500)
		DolgubonDebugRunningDebugString = ''
		zo_callLater( CloseMailbox, 1000)
	elseif len<1400 then
		RequestOpenMailbox()
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT2", string.sub(DolgubonDebugRunningDebugString,700))end , 500)
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT1", string.sub(DolgubonDebugRunningDebugString,1,700))end , 1500)
		DolgubonDebugRunningDebugString = ""
		zo_callLater( CloseMailbox, 2000)
	else
		RequestOpenMailbox()
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT3", string.sub(DolgubonDebugRunningDebugString, 1400,2100))end , 500)
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT2", string.sub(DolgubonDebugRunningDebugString, 700,1400))end , 1500)
		zo_callLater(function() SendMail("@Dolgubon", "WRIT DEBUG OUTPUT1", string.sub(DolgubonDebugRunningDebugString, 1,700))end , 2500)
		DolgubonDebugRunningDebugString = ""
		zo_callLater( CloseMailbox, 3000)
	end

end

local function dbug(...)
	DolgubonGlobalDebugOutput(...)
end

--SLASH_COMMANDS['/senddebug'] = sendDebug
--SLASH_COMMANDS['/sendebug']  = sendDebug
local trackedSealedWrits = {}
--------------------------------------------------
-- HACKING OF USEITEM
--[[
local originalUseItem = UseItem

local function newUseItem(bag, slot)
	local itemtype, special = GetItemType(bag, slot)
	if SPECIALIZED_ITEMTYPE_MASTER_WRIT ~=special then return end
	local unique = GetItemUniqueId(bag, slot)
	for i = 1, #trackedSealedWrits do
		if trackedSealedWrits[i]==unique then return end
	end
	if IsProtectedFunction("originalUseItem") then
		CallSecureProtected("originalUseItem",bag, slot)
	else

		originalUseItem(bag, slot)
	end
	originalUseItem()
end
UseItem = newUseItem]]


---------------------------------------------------
-- MASTER WRITS PROPER



local function proper(str)
	if type(str)== "string" then
		return zo_strformat("<<C:1>>",str)
	else
		return str
	end
end


local function myLower(str)
	return zo_strformat("<<z:1>>",str)-- "Rüstung der Verführung^f"
end

local function standardizeString(str)
	str = myLower(str)
	str = string.gsub(str,"-"," ")
	str = string.gsub(str,"ä","a")
	str = string.gsub(str,"ü","u")
	str = string.gsub(str,"ö","o")
	return str
end

local function strFind(str, str2find, a, b, c)
	str = standardizeString(str)
	str2find = standardizeString(str2find)
	return string.find(str, str2find, a, b, c)


end

local weaponTraits ={}
local armourTraits = {}
------------------------------------
-- TRAIT DECLARATION

function WritCreater.buildTraitTable()
	armourTraits = {}
	weaponTraits ={}
	for i = 0, 8 do --create the weapon trait table
		--Takes the strings starting at SI_ITEMTRAITTYPE0 == no trait, # 897 to SI_ITEMTRAITTYPE8 === Divines, #905
		--Then saves the proper trait index used for crafting to it. The offset of 1 is due to ZOS; the offset of STURDY is so they start at 12
		weaponTraits[i + 1] = {[2]  = i + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE0 + i)),}
	end


	for i = 0, 7 do --create the armour trait table
		--Takes the strings starting at SI_ITEMTRAITTYPE11 == Sturdy, # 908 to SI_ITEMTRAITTYPE18 === Divines, #915
		--Then saves the proper trait index used for crafting to it. The offset of 1 is due to ZOS; the offset of STURDY is so they start at 12
		armourTraits[i + 1] = {[2] = i + 1 + ITEM_TRAIT_TYPE_ARMOR_STURDY, [1] = myLower(GetString(SI_ITEMTRAITTYPE11 + i))}
	end
	--Add a few missing traits to the tables - i.e., nirnhoned, and no trait
	armourTraits[#armourTraits + 1] = {[2] = ITEM_TRAIT_TYPE_NONE + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE0))} -- No Trait to armour traits
	armourTraits[#armourTraits + 1] = {[2] = ITEM_TRAIT_TYPE_ARMOR_NIRNHONED + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE26))} -- Nirnhoned
	weaponTraits[#weaponTraits + 1] = {[2] = ITEM_TRAIT_TYPE_WEAPON_NIRNHONED + 1, [1] = myLower(GetString(SI_ITEMTRAITTYPE25))}  -- Nirnhoned
end

WritCreater.buildTraitTable()

styles = {}
for i = 1, GetNumValidItemStyles() do
	local styleItemIndex = GetValidItemStyleId(i)
	local itemName = GetItemStyleName(styleItemIndex)
	styles[#styles + 1] = {itemName,styleItemIndex }
end


local function enchantSearch(info,condition)
	for i = 1, #info do
		if strFind(condition, info[i][1]) then
			
			return info[i]
		end

	end

	return nil
end

local function foundAllEnchantingRequirements(essence, potency, aspect)
	if WritCreater.lang~="en" then return false end
	local foundAll = true
	if not essence then
		foundAll = false
		d("Essence/Effect not found")
	end
	if not potency then
		foundAll = false
		d("Level not found")
	end
	if not aspect or aspect[1]=="" then
		foundAll = false
		d("Quality not found")
	end
	return foundAll
end

local function EnchantingMasterWrit(journalIndex, sealedText, reference)
	--d(journalIndex, sealedText, reference)
	dbug("FUNCTION:EnchantingMasterHandler")
	if not reference then reference = journalIndex end
	-- "Superb Glyph of Health *Quality: Legendary *Progress:0/1"
	local condition, complete
	if sealedText then
		condition, complete = sealedText, false
	else
		condition, complete, outOf = GetJournalQuestConditionInfo(journalIndex, 1)
	end
	if complete == outOf then return end
	if condition =="" then return end

	local craftInfo = WritCreater.craftInfo[CRAFTING_TYPE_ENCHANTING]

	local essence = enchantSearch(craftInfo["pieces"], condition)
	local potency = enchantSearch(craftInfo["match"], condition)
	local aspect = enchantSearch(craftInfo["quality"], condition)

	if foundAllEnchantingRequirements(essence, potency, aspect) then
		local lvl = potency[1]
		if potency[1]=="truly" then lvl = "truly superb" end
		d(zo_strformat("<<t:4>> <<t:5>> <<t:6>>: Crafting a <<t:1>> Glyph of <<t:2>> at <<t:3>> quality", lvl, essence[1], aspect[1],
			WritCreater.langWritNames()[CRAFTING_TYPE_ENCHANTING],
			WritCreater.langMasterWritNames()["M1"],
			WritCreater.langWritNames()["G"]))
		dbug("CALL:LLCENchantCraft")
		WritCreater.LLCInteraction:CraftEnchantingItemId(potency[2][essence[3]], essence[2], aspect[2], true, reference)
	else
	end
end

local function smithingSearch(condition, info, debug)
	local matches = {}
	for i = 1, #info do

		local str = string.gsub(info[i][1], "-"," ")
		if strFind(condition, str) then
			matches[#matches+1] = {info[i] , i}
		end
	end

	if #matches== 0 then
		return {"",0} , -1
	elseif #matches==1 then

		return matches[1][1], matches[1][2]
	else
		local longest = 0
		local position = 0
		for i = 1, #matches do
			if string.len(matches[i][1][1])>longest then
				longest = string.len(matches[i][1][1])
				position = i
			end
		end
		return matches[position][1], matches[position][2]
	end

end

local function foundAllRequirements(pattern, style, setIndex, trait, quality)
	local foundAllRequirements = true
	if setIndex==-1 then 
		foundAllRequirements = false
		d("Set not found") 
	end
	if pattern[1] =="" then 
		foundAllRequirements = false
		d("Pattern not found")
	end
	if trait[1]=="" then
		foundAllRequirements = false
		d("Trait not found")
	end
	if style[1]=="" then
		foundAllRequirements = false
		d("Style not found")
	end
	if quality[1]=="" then
		foundAllRequirements = false
		d("Quality not found")
	end
	return foundAllRequirements
end

local function germanRemoveEN (str)

	return string.sub(str, 1 , string.len(str) - 2)

end

local function splitCondition(condition, isQuest)
	local seperator = "A"
	if isQuest then seperator = "\n" else seperator = ";" end
	local a = 1
	local t = {}
	while strFind(condition , seperator) and a<100 do
		a = a+1
		t[#t+1] = string.gsub(string.sub(condition, 1, strFind(condition, seperator)),"\n","")
		condition = string.sub(condition, strFind(condition,seperator) + 1, string.len(condition) ) 
		if t[#t]=="" then t[#t] = nil end
	end
	t[#t+1] = condition
	return unpack(t)
end

local function SmithingMasterWrit(journalIndex, info, station, isArmour, material, reference, sealedText)
	dbug("FUNCTION:SmithingMasterHandler")

	if WritCreater.lang == "de" then for i = 1, #info do  info[i][1] = germanRemoveEN(info[i][1])   end end
	local condition, complete =GetJournalQuestConditionInfo(journalIndex, 1)
	local isQuest = true
	if sealedText then
		isQuest = false
		condition, complete = sealedText, false
	else
	end
	
	--"Craft a Rubedite Greataxe with the following Properties:\n • Quality: Epic\n • Trait: Powered\n • Set: Oblivion's Foe\n • Style: Imperial\n • Progress: 0 / 1", false--
	condition = string.gsub(condition, "-" , " ")
	
	if complete == 1 then return end
	if condition =="" then return end
	local conditionStrings = {}
	
	conditionStrings["pattern"], conditionStrings["quality"], conditionStrings["trait"],
	  conditionStrings["set"], conditionStrings["style"] = splitCondition(condition, isQuest)


	local pattern =  smithingSearch(conditionStrings["pattern"], info) --search pattern

	if pattern[1] =="" and pattern[2]==0 then return end
	local trait
	if isArmour then
		
		trait = smithingSearch(conditionStrings["trait"], armourTraits )
	else
		trait = smithingSearch(conditionStrings["trait"], weaponTraits)
	end
	local style = smithingSearch(conditionStrings["style"], styles)
	local _,setIndex = smithingSearch(conditionStrings["set"], GetSetIndexes())
	local quality
	if WritCreater.lang =="en" then
		quality = smithingSearch(conditionStrings["quality"], {{"Epic",4},{"Legendary",5}}) --search quality
	elseif WritCreater.lang=="de" then
		quality = smithingSearch(conditionStrings["quality"], {{"episch",4},{"legendär",5}})
	elseif WritCreater.lang =="fr" then
		quality = smithingSearch(conditionStrings["quality"], {{"épique",4},{"légendaire",5}})
	end

	if foundAllRequirements(pattern, style, setIndex, trait, quality) then

		local partialString = zo_strformat("Crafting a CP150 <<t:6>> <<t:1>> from <<t:2>> with the <<t:3>> trait and style <<t:4>> at <<t:5>> quality"
			,pattern[1], 
			GetSetIndexes()[setIndex][1],
			trait[1],
			style[1], 
			quality[1],
			material			
			 )
		d(zo_strformat("<<t:2>> <<t:3>> <<t:4>>: <<1>>",
			partialString,
			WritCreater.langWritNames()[station],
			WritCreater.langMasterWritNames()["M1"],
			WritCreater.langWritNames()["G"]
			))

		dbug("CALL:LLCCraftSmithing")
		WritCreater.LLCInteraction:cancelItemByReference(reference)

		WritCreater.LLCInteraction:CraftSmithingItemByLevel( pattern[2], true , 150, style[2], trait[2], false, station, setIndex, quality[2], true, reference)
	else
		dbug("ERROR:RequirementMissing")
	end
end

local function keyValueTable(t)
	local temp = {}
	for k, v in pairs(t) do

		temp[#temp + 1] = {myLower(v),k}

	end
	return temp
end

local function partialTable(t, start, ending)

	local temp = {}
	for i = start or 1, ending or #t do 
		temp[i] = t[i]
	end
	return temp
end

--/script for 1, 25 do if GetJournalQuestName(i) == "A Masterful Weapon" then d(i, GetJournalQuestConditionInfo(i,1,1))  end end
--QuestID: 1

local exceptions = 
{
	[CRAFTING_TYPE_WOODWORKING] = 
	{
		[2] = {['en'] = "shield",['de'] = "schilden",['fr'] = "bouclier"},
		[4] = {['en'] = "frost",['de'] = "schilden",['fr'] = "bouclier"},
		[6] = {['en'] = "healing",['de'] = "schilden",['fr'] = "bouclier"},
	},
	[CRAFTING_TYPE_BLACKSMITHING] = { [4] = {['en'] = "greataxe",['de'] = '',} ,},
}

function WritCreater.MasterWritsQuestAdded(event, journalIndex,name)
	
	if not WritCreater.langMasterWritNames or not WritCreater.savedVarsAccountWide.masterWrits then return end
	local writNames = WritCreater.langMasterWritNames()
	local isMasterWrit = false
	local writType = ""
	for k, v in pairs(writNames) do
		if strFind(name, v) then
			if k == "M" then
				isMasterWrit = true
			elseif k == "M1" then
			else
				writType = k
			end

		end
	end
	--if not isMasterWrit then return end
	if not isMasterWrit then return end
	dbug("FUNCTION:MasterWritStart")
	local langInfo = WritCreater.languageInfo()
	--local info = {}
	if writType =="" then 
		return
	else
		
		if writType=="weapon" then

			local info = partialTable(langInfo[CRAFTING_TYPE_BLACKSMITHING]["pieces"] , 1, 7)
			info = keyValueTable(info)
			table.insert(info, {"greataxe",4})
			--local patternBlacksmithing =  smithingSearch(condition, info) --search pattern

			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_BLACKSMITHING, false, "Rubedite",journalIndex)

			info = partialTable(langInfo[CRAFTING_TYPE_WOODWORKING]["pieces"] , 1, 6)
			info[6] = "healing"
			info[4] = "frost"
			info = keyValueTable(info)

			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_WOODWORKING, false, "Ruby Ash",journalIndex)

		elseif writType == CRAFTING_TYPE_ALCHEMY then
		elseif writType == CRAFTING_TYPE_ENCHANTING then
			EnchantingMasterWrit(journalIndex)
		elseif writType == CRAFTING_TYPE_PROVISIONING then
		elseif writType == "shield" then
			local info = {{"shield",2}}
			if WritCreater.lang=="de" then info[1][1] ="schilden" end
			if WritCreater.lang=="fr" then info[1][1] = "bouclier" end
			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_WOODWORKING, true, "Ruby Ash",journalIndex)
		elseif writType == "plate" then
			local info = partialTable(langInfo[CRAFTING_TYPE_BLACKSMITHING]["pieces"] , 8, 14)
			info = keyValueTable(info)

			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_BLACKSMITHING, true, "Rubedite",journalIndex)
		elseif writType == "leatherwear" then
			local info = partialTable(langInfo[CRAFTING_TYPE_CLOTHIER]["pieces"] , 9, 15)
			info = keyValueTable(info)
			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_CLOTHIER, true, "Rubedo Leather",journalIndex)
		elseif writType == "tailoring" then

			local info = partialTable(langInfo[CRAFTING_TYPE_CLOTHIER]["pieces"] , 1, 8)
			info = keyValueTable(info)
			SmithingMasterWrit(journalIndex, info, CRAFTING_TYPE_CLOTHIER, true, "Ancestor Silk",journalIndex)
		end

	end

end

local function QuestCounterChanged(event, journalIndex, questName, _, _, currConditionVal, newConditionVal, conditionMax)
	dbug("EVENT:Quest Counter Change")

	WritCreater.LLCInteraction:cancelItemByReference(journalIndex)
	if newConditionVal<conditionMax then
		
		WritCreater.MasterWritsQuestAdded(event, journalIndex, questName)
	end

end


--EVENT_QUEST_ADDED found in AlchGrab File
EVENT_MANAGER:RegisterForEvent(WritCreater.name,EVENT_QUEST_CONDITION_COUNTER_CHANGED , QuestCounterChanged)

function WritCreater.scanAllQuests()
	WritCreater.LLCInteraction:cancelItem()
	dbug("FUNCTION:scanAllQuests")
	for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
end

SLASH_COMMANDS['/rerunmasterwrits'] = WritCreater.scanAllQuests



SLASH_COMMANDS['/craftitems'] = function() WritCreater.LLCInteraction:CraftAllItems() end
--
function WritCreater.InventorySlot_ShowContextMenu(rowControl,debugslot)
	
	local bag, slot, link, flavour, reference
	if type(rowControl)=="userdata" or type(rowControl)=="number" then 
		if type(rowControl)=="userdata" then
	    	bag, slot = ZO_Inventory_GetBagAndIndex(rowControl)
	    else
	    	bag , slot = rowControl, debugslot
	    end
	    link = GetItemLink(bag, slot)
	    flavour = GetItemLinkFlavorText(link)
	    if GetItemType(bag, slot)~=ITEMTYPE_MASTER_WRIT then return end
	elseif type(rowControl)=="string" then
		--Note: This is a debug ability mainly. It allows you to call the function with just a link from some random place and craft it.
		link = rowControl
	    flavour = GetItemLinkFlavorText(rowControl)
	    reference = "Test"
	end
	
    local exampleSealedWrits = {
    [CRAFTING_TYPE_CLOTHIER] = "|H1:item:121532:6:1:0:0:0:26:194:5:178:15:34:0:0:0:0:0:0:0:0:883200|h|h",
    [CRAFTING_TYPE_BLACKSMITHING] = "|H1:item:119680:6:1:0:0:0:47:188:4:240:12:29:0:0:0:0:0:0:0:0:56375|h|h",
    [CRAFTING_TYPE_WOODWORKING] = "|H1:item:119682:6:1:0:0:0:65:192:4:95:14:47:0:0:0:0:0:0:0:0:63250|h|h",
    [CRAFTING_TYPE_ENCHANTING] = "|H1:item:121528:6:1:0:0:0:26581:225:5:0:0:0:0:0:0:0:0:0:0:0:66000|h|h",
	}
	local writText = GenerateMasterWritBaseText(link)
	local station

	for k, v in pairs(exampleSealedWrits) do
		if GetItemLinkName(link) == GetItemLinkName(v) then
			station = k
		end
	end
	if not station then return end
    -- Check if you can find "Blacksmithing, Clothing Woodworking or Enchanting"
    -- Search for if it is armour or not
    if not WritCreater.savedVarsAccountWide.rightClick then return end
    zo_callLater(function ()
        AddCustomMenuItem("Craft Sealed Writ", function ()
            if station == CRAFTING_TYPE_ENCHANTING then
            	EnchantingMasterWrit(nil, writText,  GetItemUniqueId(bag, slot))
            else
            	local langInfo = WritCreater.languageInfo()
            	local material = ""
            	local info = partialTable(langInfo[station]["pieces"])
				info = keyValueTable(info)
				local isArmour
				if station == CRAFTING_TYPE_BLACKSMITHING then
					if flavour == GetItemLinkFlavorText(exampleSealedWrits[CRAFTING_TYPE_BLACKSMITHING]) then
						isArmour = true
					end
					material = "Rubedite"
					table.insert(info, {"greataxe",4})
				elseif station == CRAFTING_TYPE_WOODWORKING then
					if flavour == GetItemLinkFlavorText(exampleSealedWrits[CRAFTING_TYPE_WOODWORKING]) then
						isArmour = true
					end
					table.insert(info,{"healing",6}) 
					table.insert(info,{"frost",4}) 

					material = "Ruby Ash"
				elseif station == CRAFTING_TYPE_CLOTHIER then
					if flavour == GetItemLinkFlavorText(exampleSealedWrits[CRAFTING_TYPE_WOODWORKING]) then
						material = "Ancestor Silk"
					else
						material = "Rubedo Leather"
					end
					isArmour = true
				end
				SmithingMasterWrit(nil, info, station, isArmour, material, GetItemUniqueId(bag, slot), writText)
            end
            trackedSealedWrits[#trackedSealedWrits + 1] = {bag, slot, GetItemUniqueId(bag, slot)}
        end, MENU_ADD_OPTION_LABEL)
        ShowMenu(self)
    end, 50)
end
function WritCreater.InitializeRightClick()
	ZO_PreHook('ZO_InventorySlot_ShowContextMenu', function (rowControl) WritCreater.InventorySlot_ShowContextMenu(rowControl) end)

end

--]]
function WritCreater.checkIfMasterWritWasStarted(...)
	dbug("EVENT:SlotUpdated")
end



EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_ADD_ON_LOADED, WritCreater.OnAddOnLoaded)





-- |H1:item:119681:6:1:0:0:0:72:192:4:207:2:29:0:0:0:0:0:0:0:0:57750|h|h 
-- |H1:item:121528:6:1:0:0:0:26581:225:5:0:0:0:0:0:0:0:0:0:0:0:66000|h|h
-- Ruby Ash Shield Epic Divines Night's Silence, Dwemer
-- |H1:item:119682:6:1:0:0:0:65:192:4:40:18:14:0:0:0:0:0:0:0:0:52250|h|h
-- Ruby Ash Healing, Epic, Precise, Kagrenacs, Soul Shriven
-- |H1:item:119681:6:1:0:0:0:71:192:4:92:3:30:0:0:0:0:0:0:0:0:60500|h|h
-- Ruby Ash Frost, Epic, Decisive, Song of Lamae, Dwemer
-- |H1:item:119681:6:1:0:0:0:73:192:4:81:8:14:0:0:0:0:0:0:0:0:56375|h|h
-- Rubedite Greataxe, Epic, Defending, Twice Born Star, Xivkyn
-- |H1:item:119563:6:1:0:0:0:68:188:4:161:5:29:0:0:0:0:0:0:0:0:66000|h|h

