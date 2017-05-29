WritCreater = WritCreater or {}
local completionStrings


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

	if not writComplete then return end
	-- Increment the number of writs complete number
	WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] = WritCreater.savedVarsAccountWide["rewards"][currentWritDialogue]["num"] + 1
	WritCreater.savedVarsAccountWide["total"] = WritCreater.savedVarsAccountWide["total"] + 1
    -- Complete the writ quest
	CompleteQuest()

end
local function HandleEventQuestOffered(eventCode)
    -- Stop listening for quest offering
    EVENT_MANAGER:UnregisterForEvent(WritCreater.name, EVENT_QUEST_OFFERED)
    -- Accept the writ quest
    AcceptOfferedQuest()
end

local function isQuestTypeActive(optionString)
	optionString = string.gsub(optionString, "couture","tailleur")

	for i = 1, 6 do

		if string.find(string.lower(optionString), string.lower(WritCreater.writNames[i])) and (WritCreater.savedVars[i] or WritCreater.savedVars[i]==nil) then 
			return true
		
		end
	end

	return false
end
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
	        SelectChatterOption(1)
	    end
	end
end


function WritCreater.InitializeQuestHandling()
	EVENT_MANAGER:RegisterForEvent(WritCreater.name, EVENT_CHATTER_BEGIN, HandleChatterBegin)
	completionStrings = WritCreater.writCompleteStrings()


end