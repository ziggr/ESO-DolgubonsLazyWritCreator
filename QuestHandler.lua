WritCreater = WritCreater or {}
local completionStrings

local function completeMasterWrit(eventCode, journalIndex)
	if string.find(string.lower(GetJournalQuestName(journalIndex)),WritCreater.langMasterWritNames()["M"]) then
		--d("complete")
		CompleteQuest()
	end
end

-- Handles the dialogue where we actually complete the quest
local function HandleQuestCompleteDialog(eventCode, journalIndex)
	local writs = WritCreater.writSearch()
	local writComplete = false
	local currentWritDialogue = 0
	for i = 1, 6 do
		if type(writs[i]) == "number" then
			writComplete = writComplete or GetJournalQuestIsComplete(writs[i])
			currentWritDialogue= i
		end
	end
	EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG)
	completeMasterWrit(eventCode, journalIndex)
	if not writComplete then return end
	-- Increment the number of writs complete number
	WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] = WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] + 1
	WritCreater.savedVarsAccountWide["total"] = WritCreater.savedVarsAccountWide["total"] + 1
    -- Complete the writ quest
    
	CompleteQuest()

end

-- Handles the dialogue where we actually accept the quest
local function HandleEventQuestOffered(eventCode)
    -- Stop listening for quest offering
    EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED)
    -- Accept the writ quest
    
    AcceptOfferedQuest()
end

-- Checks if we should deal with this type of quest or not
local function isQuestTypeActive(optionString)
	optionString = string.gsub(optionString, "couture","tailleur")

	for i = 1, 6 do

		if string.find(string.lower(optionString), string.lower(WritCreater.writNames[i])) and (WritCreater.savedVars[i] or WritCreater.savedVars[i]==nil) then 
			return true
		
		end
	end

	return false
end

-- Automatically accepts master writs. Off by default but it's written so not deleting it just in case
local function handleMasterWritQuestOffered()

	local a = {GetOfferedQuestInfo()}
	-- If it is a Master Writ offering
    if string.find(a[1], "Rolis Hlaalu") and a[2] == completionStrings.masterStart and not WritCreater.savedVars.preventMasterWritAccept then

		--d("Accept")
    	AcceptOfferedQuest()
	end
end

--EVENT_MANAGER:RegisterForEvent("DolgubonsLazyWritCreatorMasterWrit", EVENT_QUEST_OFFERED, handleMasterWritQuestOffered)
-- Handles dialogue start. It will fire on any NPC dialogue, so we need to filter out a bit
local function HandleChatterBegin(eventCode, optionCount)

	if not WritCreater.savedVars.autoAccept then return end
    -- Ignore interactions with no options
    if optionCount == 0 then return end
    for i = 1, optionCount do
	    -- Get details of first option
	    local optionString, optionType = GetChatterOption(i)
	    -- If it is a writ quest option...
	    if optionType == CHATTER_START_NEW_QUEST_BESTOWAL 
	       and string.find(string.lower(optionString), string.lower(WritCreater.writNames["G"])) ~= nil 
	    then
	    	if isQuestTypeActive(optionString) then
				-- Listen for the quest offering
				EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED, HandleEventQuestOffered)
				-- Select the first writ
				SelectChatterOption(i)
			end
			
	    -- If it is a writ quest completion option
	    elseif optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
	       and string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil  
	    then
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to complete the quest
	        SelectChatterOption(1)
	    
	    -- If the goods were already placed, then complete the quest
	    elseif optionType == CHATTER_START_COMPLETE_QUEST
	       and (string.find(string.lower(optionString), string.lower(completionStrings.place)) ~= nil 
	            or string.find(string.lower(optionString), string.lower(completionStrings.sign)) ~= nil)
	    then
	        -- Listen for the quest complete dialog
	        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
	        -- Select the first option to place goods and/or sign the manifest
	        --SelectChatterOption(1)
	    elseif ZO_InteractWindowTargetAreaTitle:GetText() =="-Rolis Hlaalu-" then

		    if optionType == CHATTER_START_ADVANCE_COMPLETABLE_QUEST_CONDITIONS
		       and string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil  
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to complete the quest
		        --d("Chat")
		        SelectChatterOption(1)
		        -- If the goods were already placed, then complete the quest
		    elseif optionType == CHATTER_START_COMPLETE_QUEST
		       and (string.find(string.lower(optionString), string.lower(completionStrings.masterPlace)) ~= nil 
		            or string.find(string.lower(optionString), string.lower(completionStrings.masterSign)) ~= nil)
		    then
		        -- Listen for the quest complete dialog
		        EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_QUEST_COMPLETE_DIALOG, HandleQuestCompleteDialog)
		        -- Select the first option to place goods and/or sign the manifest
		        --d("Chat2")
		        SelectChatterOption(1)
		    end
	    end
	end
end

-- Initialize the event listener, and grab the language strings
function WritCreater.InitializeQuestHandling()
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CHATTER_BEGIN, HandleChatterBegin)
	completionStrings = WritCreater.writCompleteStrings()


end