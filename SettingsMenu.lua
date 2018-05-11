-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: SettingsMenu.lua
-- File Description: Contains the information for the settings menu
-- Load Order Requirements: None (April, after language files)
-- 
-----------------------------------------------------------------------------------

if WritCreater.lang ~= "none" then

WritCreater.styleNames = {}

for i = 1, GetNumValidItemStyles() do
	local styleItemIndex = GetValidItemStyleId(i)
	local  itemName = GetItemStyleName(styleItemIndex)
	local styleItem = GetSmithingStyleItemInfo(styleItemIndex)

	table.insert(WritCreater.styleNames,{styleItemIndex,itemName, styleItem})

end

--[[{
			type = "dropbox",
			name = "Autoloot Behaviour",
			tooltip = "Choose when the addon will autoloot writ reward containers",
			choices = {"Copy the", "Autoloot", "Never Autoloot"},
			choicesValues = {1,2,3},
			getFunc = function() if WritCreater.savedVars.ignoreAuto then return 1 elseif WritCreater.savedVars.autoLoot then return 2 else return 3 end end,
			setFunc = function(value) 
				if value == 1 then 
					WritCreater.savedVars.ignoreAuto = false
				elseif value == 2 then  
					WritCreater.savedVars.autoLoot = true
					WritCreater.savedVars.ignoreAuto = true
				elseif value == 3 then
					WritCreater.savedVars.ignoreAuto = true
					WritCreater.savedVars.autoLoot = false
				end
			end,
		},]]

local function mypairs(tableIn)
	local t = {}
	for k,v in pairs(tableIn) do
		t[#t + 1] = {k,v}
	end
	table.sort(t, function(a,b) return a[1]<b[1] end)

	return t
end

local optionStrings = WritCreater.optionStrings
local function styleCompiler()
	local submenuTable = {}
	local styleNames = WritCreater.styleNames
	for k,v in ipairs(styleNames) do

		local option = {
			type = "checkbox",
			name = zo_strformat("<<1>>", v[2]),
			tooltip = optionStrings["style tooltip"](v[2], v[3]),
			getFunc = function() return WritCreater.savedVars.styles[v[1]] end,
			setFunc = function(value)
				WritCreater.savedVars.styles[v[1]] = value or nil
				end,
		}
		submenuTable[#submenuTable + 1] = option
	end
	return submenuTable
end


function WritCreater.Options() --Sentimental


if WritCreater.alternateUniverse and WritCreater.savedVarsAccountWide.alternateUniverse then
	local stations, stationNames = WritCreater.alternateUniverse()
	
	local function setupReplacement(object, functionName, positionOfText, types)
		local stationsToCheck = {}
		if types then
			stationsToCheck = stations
		else
			for i = 1, #types do 
				stationsToCheck[types] = stations[types]
			end
		end
		local original = object[functionName]
		object[functionName] = function(self, ...)
		local parameters = {...}
			local text = parameters[positionOfText]
			for i, stationOriginalName in pairs(stationsToCheck) do 
				if string.find(text, stations[i]) then
					local newText = string.gsub(text, stations[i], stationNames[i] or text or "")
					parameters[positionOfText] = newText
					original(self, unpack(parameters))
					return
				end
			end
			original(self, ...)
		end
	end
	-- unstuck yourself prompts do use the string overwrite functions
	SafeAddString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT,string.gsub(GetString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT_TELVAR), stations[9], stationNames[9]), 2)
	SafeAddString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT_TELVAR, string.gsub(GetString(SI_CUSTOMER_SERVICE_UNSTUCK_COST_PROMPT_TELVAR), stations[9], stationNames[9]), 2)

	setupReplacement(ZO_ReticleContainerInteractContext, "SetText", 1, true) -- reticle
	setupReplacement(InformationTooltip, "AddLine", 1, true) -- tooltips
	setupReplacement(ZO_CompassCenterOverPinLabel, "SetText", 1, {9}) -- compass words
	setupReplacement(ZO_Dialog1Text, "SetText", 1, {9}) -- dialog porting box
	setupReplacement(_G, "ZO_Alert", 2, {9}) -- location change notification (top right of screen)
	setupReplacement(ZO_DeathReleaseOnlyButton1NameLabel, "SetText", 1, {9}) -- when you only have one port option on death
	setupReplacement(ZO_DeathTwoOptionButton2NameLabel, "SetText", 1, {9}) -- when you can revive here or go to wayshrine
	-- checkboxes to show wayshrines on map. This one needs to be delayed because the map is not initialized at first
	local runOnce = {}
	SCENE_MANAGER.scenes['worldMap']:RegisterCallback("StateChange", function(old, new) 
	if new ~= "shown" then return end
	if not runOnce['worldMap'] then 
		runOnce['worldMap'] = true
		setupReplacement(ZO_WorldMapFiltersPvECheckBox2Label, "SetText", 1, {9})
		ZO_WorldMapFiltersPvECheckBox2Label:SetText(ZO_WorldMapFiltersPvECheckBox2Label:GetText()) 
	end  
end)
end


	local options =  {
			{
				type = "checkbox",
				name = optionStrings["show craft window"],
				tooltip =WritCreater.optionStrings["show craft window tooltip"],
				getFunc = function() return WritCreater.savedVars.showWindow end,
				setFunc = function(value) 
					WritCreater.savedVars.showWindow = value
					if value == false then
						WritCreater.savedVars.autoCraft = true
					end
				end,
			},
			{
				type = "checkbox",
				name = WritCreater.optionStrings["autocraft"]  ,
				tooltip = WritCreater.optionStrings["autocraft tooltip"] ,
				getFunc = function() return WritCreater.savedVars.autoCraft end,
				disabled = function() return not WritCreater.savedVars.showWindow end,
				setFunc = function(value) 
					WritCreater.savedVars.autoCraft = value 
				end,
			},
			
			
			{
				type = "checkbox",
				name = WritCreater.optionStrings["master"],--"Master Writs",
				tooltip = WritCreater.optionStrings["master tooltip"],--"Craft Master Writ Items",
				getFunc = function() return WritCreater.savedVarsAccountWide.masterWrits end,
				setFunc = function(value) 
				WritCreater.savedVarsAccountWide.masterWrits = value
				WritCreater.savedVarsAccountWide.rightClick = not value
				WritCreater.LLCInteraction:cancelItem()
					if value  then
						
						for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
					end
					
					
				end,
			},
			{
				type = "checkbox",
				name = WritCreater.optionStrings["right click to craft"],--"Master Writs",
				tooltip = WritCreater.optionStrings["right click to craft tooltip"],--"Craft Master Writ Items",
				getFunc = function() return WritCreater.savedVarsAccountWide.rightClick end,
				setFunc = function(value) 
				WritCreater.savedVarsAccountWide.masterWrits = not value
				WritCreater.savedVarsAccountWide.rightClick = value
				WritCreater.LLCInteraction:cancelItem()
					if not value  then
						
						for i = 1, 25 do WritCreater.MasterWritsQuestAdded(1, i,GetJournalQuestName(i)) end
					end
				end,
			},
			
	}
----------------------------------------------------
----- TIMESAVER SUBMENU

	local timesaverOptions =
	{
		{
			type = "checkbox",
			name = WritCreater.optionStrings["automatic complete"],
			tooltip = WritCreater.optionStrings["automatic complete tooltip"],
			getFunc = function() return WritCreater.savedVars.autoAccept end,
			setFunc = function(value) WritCreater.savedVars.autoAccept = value end,
		},		
		{
			type = "checkbox",
			name = WritCreater.optionStrings["exit when done"],
			tooltip = WritCreater.optionStrings["exit when done tooltip"],
			getFunc = function() return WritCreater.savedVars.exitWhenDone end,
			setFunc = function(value) WritCreater.savedVars.exitWhenDone = value end,
		},
		{
			type = "dropdown",
			name = WritCreater.optionStrings["autoloot behaviour"]	,
			tooltip = WritCreater.optionStrings["autoloot behaviour tooltip"],
			choices = WritCreater.optionStrings["autoloot behaviour choices"],
			choicesValues = {1,2,3},
			getFunc = function() if not WritCreater.savedVars.ignoreAuto then return 1 elseif WritCreater.savedVars.autoLoot then return 2 else return 3 end end,
			setFunc = function(value) 
				if value == 1 then 
					WritCreater.savedVars.ignoreAuto = false
				elseif value == 2 then  
					WritCreater.savedVars.autoLoot = true
					WritCreater.savedVars.ignoreAuto = true
				elseif value == 3 then
					WritCreater.savedVars.ignoreAuto = true
					WritCreater.savedVars.autoLoot = false
				end
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["new container"],
			tooltip = WritCreater.optionStrings["new container tooltip"],
			getFunc = function() return WritCreater.savedVars.keepNewContainer end,
			setFunc = function(value) 
			WritCreater.savedVars.keepNewContainer = value			
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["loot container"],
			tooltip = WritCreater.optionStrings["loot container tooltip"],
			getFunc = function() return WritCreater.savedVars.lootContainerOnReceipt end,
			setFunc = function(value) 
			WritCreater.savedVars.lootContainerOnReceipt = value					
			end,
		},
		--[[{
			type = "slider",
			name = WritCreater.optionStrings["container delay"],
			tooltip = WritCreater.optionStrings["container delay tooltip"]    ,
			min = 0,
			max = 5,
			getFunc = function() return WritCreater.savedVars.containerDelay end,
			setFunc = function(value)
			WritCreater.savedVars.containerDelay = value
			end,
			disabled = function() return not WritCreater.savedVars.lootContainerOnReceipt end,
		  },--]]
		{
			type = "checkbox",
			name = WritCreater.optionStrings["master writ saver"],
			tooltip = WritCreater.optionStrings["master writ saver tooltip"],
			getFunc = function() return WritCreater.savedVars.preventMasterWritAccept end,
			setFunc = function(value) 
			WritCreater.savedVars.preventMasterWritAccept = value					
			end,
		},
		{
			type = "checkbox",
			name = WritCreater.optionStrings["loot output"],--"Master Writs",
			tooltip = WritCreater.optionStrings["loot output tooltip"],--"Craft Master Writ Items",
			getFunc = function() return WritCreater.savedVars.lootOutput end,
			setFunc = function(value) 
			WritCreater.savedVars.lootOutput = value					
			end,
		},
		
	}
	
----------------------------------------------------
----- CRAFTING SUBMENU

	local craftSubmenu = {{
		type = "checkbox",
		name = WritCreater.optionStrings["blackmithing"]   ,
		tooltip = WritCreater.optionStrings["blacksmithing tooltip"] ,
		getFunc = function() return WritCreater.savedVars[CRAFTING_TYPE_BLACKSMITHING] end,
		setFunc = function(value) 
			WritCreater.savedVars[CRAFTING_TYPE_BLACKSMITHING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["clothing"]  ,
		tooltip = WritCreater.optionStrings["clothing tooltip"] ,
		getFunc = function() return WritCreater.savedVars[CRAFTING_TYPE_CLOTHIER] end,
		setFunc = function(value) 
			WritCreater.savedVars[CRAFTING_TYPE_CLOTHIER] = value 
		end,
	},
	{
	  type = "checkbox",
	  name = WritCreater.optionStrings["woodworking"]    ,
	  tooltip = WritCreater.optionStrings["woodworking tooltip"],
	  getFunc = function() return WritCreater.savedVars[CRAFTING_TYPE_WOODWORKING] end,
	  setFunc = function(value) 
		WritCreater.savedVars[CRAFTING_TYPE_WOODWORKING] = value 
	  end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["enchanting"],
		tooltip = WritCreater.optionStrings["enchanting tooltip"]  ,
		getFunc = function() return WritCreater.savedVars[CRAFTING_TYPE_ENCHANTING] end,
		setFunc = function(value) 
			WritCreater.savedVars[CRAFTING_TYPE_ENCHANTING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["provisioning"],
		tooltip = WritCreater.optionStrings["provisioning tooltip"]  ,
		getFunc = function() return WritCreater.savedVars[CRAFTING_TYPE_PROVISIONING] end,
		setFunc = function(value) 
			WritCreater.savedVars[CRAFTING_TYPE_PROVISIONING] = value 
		end,
	},
	{
		type = "checkbox",
		name = WritCreater.optionStrings["alchemy"],
		tooltip = WritCreater.optionStrings["alchemy tooltip"]  ,
		getFunc = function() return WritCreater.savedVars[CRAFTING_TYPE_ALCHEMY] end,
		setFunc = function(value) 
			WritCreater.savedVars[CRAFTING_TYPE_ALCHEMY] = value 
		end,
	},}

  if WritCreater.lang ~="jp" then
  table.insert(options, {
	type = "checkbox",
	name = WritCreater.optionStrings["writ grabbing"] ,
	tooltip = WritCreater.optionStrings["writ grabbing tooltip"] ,
	getFunc = function() return WritCreater.savedVars.shouldGrab end,
	setFunc = function(value) WritCreater.savedVars.shouldGrab = value end,
  })
  --[[table.insert(options,{
	type = "slider",
	name = WritCreater.optionStrings["delay"],
	tooltip = WritCreater.optionStrings["delay tooltip"]    ,
	min = 10,
	max = 2000,
	getFunc = function() return WritCreater.savedVars.delay end,
	setFunc = function(value)
	WritCreater.savedVars.delay = value
	end,
	disabled = function() return not WritCreater.savedVars.shouldGrab end,
  })]]
  end

	if false --[[GetWorldName() == "NA Megaserver" and WritCreater.lang =="en" ]] then
	  table.insert(options,8, {
	  type = "checkbox",
	  name = WritCreater.optionStrings["send data"],
	  tooltip =WritCreater.optionStrings["send data tooltip"] ,
	  getFunc = function() return WritCreater.savedVarsAccountWide.sendData end,
	  setFunc = function(value) WritCreater.savedVarsAccountWide.sendData = value  end,
	}) 
	end
	table.insert(options,{
	  type = "submenu",
	  name = WritCreater.optionStrings["timesavers submenu"],
	  tooltip = WritCreater.optionStrings["timesavers submenu tooltip"],
	  controls = timesaverOptions,
	  reference = "WritCreaterTimesaverSubmenu",
	})
	table.insert(options,{
	  type = "submenu",
	  name =WritCreater.optionStrings["style stone menu"],
	  tooltip = WritCreater.optionStrings["style stone menu tooltip"]  ,
	  controls = styleCompiler(),
	  reference = "WritCreaterStyleSubmenu",
	})

	table.insert(options,{
	  type = "submenu",
	  name = WritCreater.optionStrings["crafting submenu"],
	  tooltip = WritCreater.optionStrings["crafting submenu tooltip"],
	  controls = craftSubmenu,
	  reference = "WritCreaterMasterWritSubMenu",
	})
	if WritCreater.alternateUniverse then
		table.insert(options,1, {
				type = "checkbox",
				name = WritCreater.optionStrings["alternate universe"],
				tooltip =WritCreater.optionStrings["alternate universe tooltip"] ,
				getFunc = function() return WritCreater.savedVarsAccountWide.alternateUniverse end,
				setFunc = function(value) WritCreater.savedVarsAccountWide.alternateUniverse = value  end,
				requiresReload = true
			})
	end


	return options
end

else
	d("Language not supported")
end
