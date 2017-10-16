-----------------------------------------------------------------------------------
-- Addon Name: Dolgubon's Lazy Writ Crafter
-- Creator: Dolgubon (Joseph Heinzle)
-- Addon Ideal: Simplifies Crafting Writs as much as possible
-- Addon Creation Date: March 14, 2016
--
-- File Name: Languages/de.lua
-- File Description: German Localization
-- Load Order Requirements: None
-- 
-----------------------------------------------------------------------------------

function WritCreater.langWritNames() --Exacts!!!  I know for german alchemy writ is Alchemistenschrieb - so ["G"] = schrieb, and ["A"]=Alchemisten
	local names = {
	["G"] = "schrieb",
	[CRAFTING_TYPE_ENCHANTING] = "Verzauberer",
	[CRAFTING_TYPE_BLACKSMITHING] = "Schmiede",
	[CRAFTING_TYPE_CLOTHIER] = "Schneider",
	[CRAFTING_TYPE_PROVISIONING] = "Versorger",
	[CRAFTING_TYPE_WOODWORKING] = "Schreiner",
	[CRAFTING_TYPE_ALCHEMY] = "Alchemisten",
	}
	return names
end

function WritCreater.writCompleteStrings()
	local strings = {
	["place"] = "Die Waren in die Kiste legen",
	["sing"] = "Das Manifest unterschreiben",
	["masterStart"] = "<Nehmt den Auftrag an.>",
	["masterSign"] = "<Auftrag abschließen.>",
	["masterPlace"] = "Ich habe den ",
	}
	return strings
end

function WritCreater.langMasterWritNames()
	local names = {
	["M"] 							= "meisterhafte",
	["M1"]							= "meister",
	[CRAFTING_TYPE_ALCHEMY]			= "gebräu",
	[CRAFTING_TYPE_ENCHANTING]		= "glyphe",
	[CRAFTING_TYPE_PROVISIONING]	= "mahl",
	["plate"]						= "rüstung",
	["tailoring"]					= "nähkunst",
	["leatherwear"]					= "lederwaren",
	["weapon"]						= "waffe",
	["shield"]						= "schild",
	}
return names

end

function WritCreater.languageInfo() --exacts!!!

local craftInfo = 
	{
		[ CRAFTING_TYPE_CLOTHIER] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "Roben",
				[2] = "Jacken",
				[3] = "Schuhe",
				[4] = "Handschuhe",
				[5] = "Hüte",
				[6] = "Beinkleider",
				[7] = "Schulterpolster",
				[8] = "Schärpen",
				[9] = "Wämser",
				[10] = "Stiefel",
				[11] = "Armschienen",
				[12] = "Helme",
				[13] = "Schoner",
				[14] = "Schulterkappen",
				[15] = "Riemen",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Homespun Robe, Linen Robe
			{
				[1] = "Jute", --lvtier one of mats
				[2] = "Flachs",	--l
				[3] = "Baumwoll",
				[4] = "Spinnenseiden",
				[5] = "Ebengarn",
				[6] = "Kresh",
				[7] = "Eisenstoff",
				[8] = "Silberstoff",
				[9] = "Leerenstoff",
				[10] = "Ahnenseiden",
				[11] = "Rohleder",
				[12] = "Halbleder",
				[13] = "Leder",
				[14] = "Hartleder",
				[15] = "Wildleder",
				[16] = "Rauleder",
				[17] = "Eisenleder",
				[18] = "Prächtige",
				[19] = "Schattenleder",
				[20] = "Rubedoleder",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "Jute", 
				[2] = "Flachs",	
				[3] = "Baumwolle",
				[4] = "Spinnenseide",
				[5] = "Ebengarn",
				[6] = "Kreshfasern",
				[7] = "Eisenstoff",
				[8] = "Silberstoff",
				[9] = "Leerenstoff",
				[10] = "Ahnenseide",
				[11] = "Rohleder",
				[12] = "Halbleder",
				[13] = "Leder",
				[14] = "Hartleder",
				[15] = "Wildleder",
				[16] = "Rauleder",
				[17] = "Eisenleder",
				[18] = "Prachtleder",
				[19] = "Schattenleder",
				[20] = "Rubedoleder",
			}		
		},
		[CRAFTING_TYPE_BLACKSMITHING] = 
		{
			["pieces"] = --exact!!
			{
				[1] = "Äxte",
				[2] = "Keulen",
				[3] = "Schwerter",
				[4] = "Streitäxte",
				[5] = "Streitkolben",
				[6] = "Bidenhänder",
				[7] = "Dolche",
				[8] = "Kürasse",
				[9] = "Panzerschuhe",
				[10] = "Hentzen",
				[11] = "Hauben",
				[12] = "Beinschienen",
				[13] = "Schulterschutze",
				[14] = "Gürtel",
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Iron Axe, Steel Axe
			{
				[1] = "Eisen",
				[2] = "Stahl",
				[3] = "Oreichalkos",
				[4] = "Dwemer",
				[5] = "Ebenerz",
				[6] = "Kalzinium",
				[7] = "Galatit",
				[8] = "Flinksilber",
				[9] = "Leerenstahl",
				[10] = "Rubedit",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "Eisenbarren",
				[2] = "Stahlbarren",
				[3] = "Oreichalkosbarren",
				[4] = "Dwemrbarren",
				[5] = "Ebenerzbarren",
				[6] = "Kalziniumbarren",
				[7] = "Galatitbarren",
				[8] = "Flinksilberbarren",
				[9] = "Leerenstahlbarren",
				[10]= "Rubeditbarren",
			}
		},
		[CRAFTING_TYPE_WOODWORKING] = 
		{
			["pieces"] = --Exact!!!
			{
				[1] = "Bogen",
				[2] = "Schilde",
				[3] = "Flammenstäbe",
				[4] = "Froststäbe",
				[5] = "Blitzstäbe",
				[6] = "Heilungsstäbe",
				
			},
			["match"] = --exact!!! This is not the material, but rather the prefix the material gives to equipment. e.g. Maple Bow. Oak Bow.
			{
				[1] = "Ahorn",
				[2] = "Eichen",
				[3] = "Buchen",
				[4] = "Hickory",
				[5] = "Eiben",
				[6] = "Birken",
				[7] = "Eschen",
				[8] = "Mahagoni",
				[9] = "Nachtholz",
				[10] = "Rubineschen",
			},
			["names"] = --Does not strictly need to be exact, but people would probably appreciate it
			{
				[1] = "Geschliffener Ahorn",
				[2] = "Geschliffene Eiche",
				[3] = "Geschliffene Buche",
				[4] = "Geschliffenes Hickory",
				[5] = "Geschliffene Eibe",
				[6] = "Geschliffene Birke",
				[7] = "Geschliffene Esche",
				[8] = "Geschliffenes Mahagoni",
				[9] = "Geschliffenes Nachtholz",
				[10] = "Geschliffene Rubinesche",
			}
		},
		[CRAFTING_TYPE_ENCHANTING] = 
		{
			["pieces"] = --exact!!
			{

				{"Seuchenresistenz", 45841,2},
				{"Fäulnis", 45841,1},
				{"Ausdauerabsorption", 45833,2},
				{"Magickaabsorption", 45832,2},
				{"Lebensabsorption", 45831,2},
				{"Frostresistenz",45839,2},
				{"Frosts",45839,1},
				{"Fähigkeitenkostenminderung", 45836,2},
				{"Ausdauerregeneration", 45836,1},
				{"Abhärtung", 45842,1},
				{"Zerschmetterns", 45842,2},
				{"prismatischen Ansturms", 68342,2},
				{"prismatischen Verteidigung", 68342,1},
				{"Einschlagens",45849,1},
				{"Abschirmens",45849,2},
				{"Giftresistenz",45837,2},
				{"Gifts",45837,1},
				{"verringerten magischen Schadens",45848,2},
				{"erhöhten magischen Schadens",45848,1},
				{"Magickaregeneration", 45835,1},
				{"Zauberkostenminderung", 45835,2},
				{"Schockresistenz",45840,2},
				{"Schocks",45840,1},
				{"Lebensregeneration",45834,1},
				{"Lebensminderung",45834,2},
				{"Schwächung",45843,2},
				{"Waffenschadens",45843,1},
				{"Trankverbesserung",45846,1},
				{"Tranktempos",45846,2},
				{"Flammenresistenz",45838,2},
				{"Flamme",45838,1},
				{"verringerten physischen Schadens", 45847,2},
				{"erhöhten physischen Schadens", 45847,1},
				{"Ausdauer",45833,1},
				{"Lebens",45831,1},
				{"Magicka",45832,1},
			},
			["match"] = --exact!!! The names of glyphs. The prefix (in English) So trifling glyph of magicka, for example
			{
				{"unbedeutende",45855},
				{"minderwertige",45856},
				{"winzige",45857},
				{"schwache",45806},
				{"niedere",45807},
				{"geringe",45808},
				{"moderate",45809},
				{"durchschnittliche",45810},
				{"starke",45811},
				{"stärkere",45812},
				{"hervorragende",45813},
				{"gewaltige",45814},
				{"vortreffliche",45815},
				{"monumentale",45816},
				{"prächtige",{64509,64508}},
				{"wahrlich prächtige",{68341,68340}},
			},
			["quality"] = 
			{
				{"legendär", 45854},
				{"episch", 45853},
				{"", 45850}
			}
		},
	}

	return craftInfo

end

function WritCreater.langEssenceNames() --exact!

local essenceNames =  
	{
		[1] = "Oko", --health
		[2] = "Deni", --stamina
		[3] = "Makko", --magicka
	}
	return essenceNames
end

function WritCreater.langPotencyNames() --exact!! Also, these are all the positive runestones - no negatives needed.
	local potencyNames = 
	{
		[1] = "Jora", --Lowest potency stone lvl
		[2] = "Porade",
		[3] = "Jera",
		[4] = "Jejora",
		[5] = "Odra",
		[6] = "Pojora",
		[7] = "Edora",
		[8] = "Jaera",
		[9] = "Pora",
		[10]= "Denara",
		[11]= "Rera",
		[12]= "Derado",
		[13]= "Rekura",
		[14]= "Kura",
		[15]= "Rejera",
		[16]= "Repora", --v16 potency stone
		
	}
	return potencyNames
end



local enExceptions = -- This is a slight misnomer. Not all are corrections - some are changes into english so that future functions will work
{
	["original"] =
	{
		[1] = "beschafft",
		[2] = "beliefert",

	},
	["corrected"] = 
	{	
		[1] = "acquire",
		[2] = "deliver",

	},
}

local exceptions = -- This is a slight misnomer. Not all are corrections - some are changes into english so that future functions will work
{
	["original"] =
	{
		[1] = "beliefert",
		[2] = "bögen",
	},
	["corrected"] = 
	{
		[1] = "deliver",
		[2] = "bogen",
	},
}

local function temporaryCheck(condition,info)
	
	for i = 9, 15 do
		if string.find(condition, info[CRAFTING_TYPE_CLOTHIER]["match"][i]) then
			return false
		end
	end
	return true
end

local bankExceptions = 
{
	["original"] = {
		"essenzen",
		"arenthischen",
		"gelnden",
		"heiligen",
		"atherischen",
	},
	["corrected"] = {
		"essenz",
		"arenthischer",
		"gelnder",
		"Heiliger",
		"atherischer",
	}
}

function WritCreater.bankExceptions(condition)
	
	if string.find(condition, "beliefert") then
		return ""
	end
	condition = string.gsub(condition, ":", " ")
	for i = 1, #bankExceptions["original"] do
		condition = string.gsub(condition,bankExceptions["original"][i],bankExceptions["corrected"][i])
	end
	return condition
end

function WritCreater.exceptions(condition)
	local location = GetCraftingInteractionType()
	if location == 0 then return condition end
	condition = string.lower(condition)
	local info = WritCreater.languageInfo()
	for i = 1, #info[location]["match"] do
		condition = string.gsub(condition,string.lower(info[location]["match"][i]),string.lower(info[location]["match"][i].." "))

	end
	
	if location ==CRAFTING_TYPE_WOODWORKING  then
		condition = string.gsub(condition,"rubeditholz", "rubineschen ")
		condition = string.gsub(condition,"rubedit", "rubineschen ")

	elseif location ==CRAFTING_TYPE_CLOTHIER and temporaryCheck(condition,info) then
		condition = string.gsub(condition,"rubeditstoff", "ahnenseiden ")
		condition = string.gsub(condition,"rubedit", "ahnenseiden ")
		
	elseif location ==CRAFTING_TYPE_CLOTHIER then
		condition = string.gsub(condition,"rubeditleder", "rubedoleder ")
		condition = string.gsub(condition,"rubedit", "rubedoleder ")
		
	end


	for i = 1, #exceptions["original"] do
		condition = string.gsub(condition,exceptions["original"][i],exceptions["corrected"][i])
	end
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.questExceptions(condition)
	condition = string.gsub(condition, " "," ")
	return condition
end

function WritCreater.enchantExceptions(condition)
	condition = string.gsub(condition, " "," ")
	condition = string.lower(condition)
	for i = 1, #enExceptions["original"] do
		condition = string.gsub(condition,enExceptions["original"][i],enExceptions["corrected"][i])
	
	end
	return condition
end


function WritCreater.langTutorial(i) --sentimental
	local t = {
		[5]="Hier noch ein paar Dinge die du wissen solltest.\nDer Chat-Befehl \'/dailyreset\' zeigt dir die Wartezeit an,\nbis du die nächsten Handwerksdailies machen kannst.",
		[4]="Als letzte Information: Im Standard ist das AddOn für alle Berufe aktiviert.\nDu kannst aber in den AddOn Einstellungen die gewünschten Berufe ein-/ausschalten.",
		[3]="Als Nächstes kannst du dich entscheiden, ob dieses Fenster angezeigt werden soll, solange du dich an einer Handwerksstation befindest.\nDieses Fenster zeigt dir wieviele Materialien für das Herstellen benötigt werden und wieviele du aktuell besitzt.",
		[2]="Wenn aktiv werden deine Sachen automatisch beim Betreten einer Handwerksstation hergestellt.",
		[1]="Willkommen zu Dolgubon's Lazy Writ Crafter!\nEs gibt ein paar Einstellungen die du zunächst festlegen\n solltest. Du kannst die Einstellungen jederzeit bei\nAddOn in Einstellungen >> Erweiterungen Menü ändern.",
	}
	return t[i]
end

function WritCreater.langTutorialButton(i,onOrOff) --sentimental and short pls
	local tOn = 
	{
		[1]="Standardoptionen",
		[2]="An",
		[3]="Zeigen",
		[4]="Weiter",
		[5]="Fertig",
	}
	local tOff=
	{
		[1]="Weiter",
		[2]="Aus",
		[3]="Verbergen",
	}
	if onOrOff then
		return tOn[i]
	else
		return tOff[i]
	end
end


local function runeMissingFunction(ta,essence,potency)
	local missing = {}
	if not ta["bag"] then
		missing[#missing + 1] = "|rTa|cf60000"
	end
	if not essence["bag"] then
		missing[#missing + 1] =  "|cffcc66"..essence["slot"].."|cf60000"
	end
	if not potency["bag"] then
		missing[#missing + 1] = "|c0066ff"..potency["slot"].."|r"
	end
	local text = ""
	for i = 1, #missing do
		if i ==1 then
			text = "|cf60000Glyphe kann nicht hergestellt werden.\nNicht genügend "..missing[i]
		else
			text = text.." oder "..missing[i]
		end
	end
	return text

	
end


WritCreater.strings = {
	["runeReq"] 								= function (essence, potency) return "|c2dff00Benötigt 1 |rTa|c2dff00, 1 |cffcc66"..essence.."|c2dff00 und ein |c0066ff"..potency end,
	["runeMissing"] 							= runeMissingFunction,
	["notEnoughSkill"]							= "Du hast nicht genügend Fertigkeitspunkte im Handwerk, um den Gegenstand herzustellen.",
	["smithingMissing"] 						= "\n|cf60000Nicht genügend Materialien|r",
	["craftAnyway"] 							= "Trotzdem herstellen",
	["smithingEnough"] 							= "\n|c2dff00Du hast genügend Materialien",
	["craft"] 									= "|c00ff00Herstellen|r",
	["smithingReqM"] 							= function(amount, type, more) return "Benötigt "..amount.." "..type.." (|cf60000"..more.." benötigt|r)" end,
	["smithingReqM2"] 							= function (amount,type,more) return "\n"..amount.." "..type.." (|cf60000"..more.." benötigt|r)" end,
	["smithingReq"] 							= function (amount,type, current) return "Benötigt "..amount.." "..type.." (|c2dff00"..current.." verfügbar|r)" end,
	["smithingReq2"] 							= function (amount,type, current) return "\n"..amount.." "..type.." (|c2dff00"..current.." verfügbar|r)" end,
	["crafting"] 								= "|cffff00Herstellung...|r",
	["craftIncomplete"] 						= "|cf60000Die Herstellung konnte nicht abgeschlossen werden.\nDu benötigst mehr Materialien.|r",
	["moreStyle"] 								= "|cf60000Du hast keine der ausgewählten Stilsteine vorhanden|r",
	["dailyreset"] 								= function (till) d(till["hour"].." Stunden und "..till["minute"].." Minuten bis zum Daily Reset") end,
	["complete"] 								= "|c00FF00Der Schrieb ist fertig|r",
	["craftingstopped"] 						= "Herstellung gestoppt. Bitte überprüfe, ob das AddOn den richtigen Gegenstand herstellt.",
	["lootReceived"]							= "<<1>> erhalten",
	["countSurveys"]							= "Du hast <<1>> Gutachten",
	["countVouchers"]							= "Du hast <<1>> offene Schriebscheine",
}

WritCreater.optionStrings = {}
WritCreater.optionStrings["style tooltip"]                            = function (styleName, styleStone) return zo_strformat("Allow the <<1>> style, which uses <<2>> to be used for crafting",styleName) end  
WritCreater.optionStrings["show craft window"]                        = "Zeige Writ Crafter Fenster"
WritCreater.optionStrings["show craft window tooltip"]                = "Zeige das Writ Crafter Fenster während du an einer Handwerksstation bist"
WritCreater.optionStrings["autocraft"]                                = "Automatisches herstellen"
WritCreater.optionStrings["autocraft tooltip"]                        = "Bei Aktivierung dieser Funktion wird Writ Crafter automatisch mit dem Herstellen beginnen, sobald ihr bei einer Handwerksstation seid. Wird das Writ Craft Fenster nicht angezeigt, wird diese Funktion eingeschaltet sein."
WritCreater.optionStrings["blackmithing"]                             = "Schmiede"
WritCreater.optionStrings["blacksmithing tooltip"]                    = "Addon für Schmiede ausschalten"
WritCreater.optionStrings["clothing"]                                 = "Schneider"
WritCreater.optionStrings["clothing tooltip"]                         = "Addon für Schneider ausschalten"
WritCreater.optionStrings["enchanting"]                               = "Verzauberer"
WritCreater.optionStrings["enchanting tooltip"]                       = "Addon für Verzauberer ausschalten"
WritCreater.optionStrings["alchemy"]                                  = "Alchemisten"
WritCreater.optionStrings["alchemy tooltip"]   	                  	  = "Addon für Alchemisten ausschalten"
WritCreater.optionStrings["provisioning"]                             = "Versorger"
WritCreater.optionStrings["provisioning tooltip"]                     = "Addon für Versorger ausschalten"
WritCreater.optionStrings["woodworking"]                              = "Schreiner"
WritCreater.optionStrings["woodworking tooltip"]                      = "Addon für Schreiner ausschalten"
WritCreater.optionStrings["ignore autoloot"]                          = "Ignoriere 'immer alles einsammeln'"
WritCreater.optionStrings["ignore autoloot tooltip"]                  = "Die Einstellung ignoriert das automatische Einsammeln (Einstellungen/Spielwelt) und benutzt dafür die Einstellung \'Einsammeln Belohnungs-Behälter\' von diesem AddOn"
WritCreater.optionStrings["autoloot containters"]                     = "automtisches Einsammeln Belohnungs-Behälter"
WritCreater.optionStrings["autoLoot containters tooltip"]             = "Ermöglicht das automatische einsammeln des Inhalts der Belohnungs-Behälter aus Handwerksquests unabhänging von der Spieleinstellung"
WritCreater.optionStrings["style stone menu"]                         = "Stilmaterial"
WritCreater.optionStrings["style stone menu tooltip"]                 = "Wähle aus, welches Stilmaterial benutzt werden soll."
WritCreater.optionStrings["exit when done"]                           = "Schließe Handwerksfenster"
WritCreater.optionStrings["exit when done tooltip"]                   = "Schließe Handwerksfenster nachdem alle Aufgaben abgeschlossen sind"
WritCreater.optionStrings["automatic complete"]                       = "Automatischer Quest Dialog"
WritCreater.optionStrings["automatic complete tooltip"]					= "Automatisches annehmen und abschließen der Quests bei erreichen und einmaligem aktivieren des benötigten Ortes"
WritCreater.optionStrings["new container"]								= "Behalte neuen Status"
WritCreater.optionStrings["new container tooltip"]						= "Behalte neuen Status für Schrieb-Belohnungs-Behälter"
WritCreater.optionStrings["master"]										= "Meisterschriebe"
WritCreater.optionStrings["master tooltip"]								= "Ein/Ausschalten ob Meisterschriebe automatisch hergestellt werden"
WritCreater.optionStrings["right click to craft"]						= "Rechtsklick zum Craften"
WritCreater.optionStrings["right click to craft tooltip"]				= "Wenn diese Einstellung aktiv ist, wird das AddOn Masterwrits craften, nachdem sie durch einen Rechtsklick aktiviert wurden"
WritCreater.optionStrings["crafting submenu"]							= "Zu bearbeitende Handwerke"
WritCreater.optionStrings["crafting submenu tooltip"]					= "Ein/Ausschalten von bestimmten Handwerken"
WritCreater.optionStrings["timesavers submenu"]							= "Zeitsparer"
WritCreater.optionStrings["timesavers submenu tooltip"]					= "Diverse kleine Zeitsparer"
WritCreater.optionStrings["loot container"]								= "Plündern von Belohnungs-Behältern"
WritCreater.optionStrings["loot container tooltip"]						= "Automatisches Plündern der Handwerksschrieb-Belohnungs-Behälter bei Erhalt"
WritCreater.optionStrings["master writ saver"]							= "Meisterschriebe sperren"
WritCreater.optionStrings["master writ saver tooltip"]					= "Sperrt die Möglichkeit Meisterschriebe anzunehmen"
WritCreater.optionStrings["loot output"]								= "Wertvolle Belohnung Hinweis"
WritCreater.optionStrings["loot output tooltip"]						= "Gebe eine Nachricht aus sobald du wertvolle Gegenstände aus einem Schrieb erhälst"
WritCreater.optionStrings["writ grabbing"]								= "Gegenstände entnehmen"
WritCreater.optionStrings["writ grabbing tooltip"]						= "Entnimmt Gegenstände die für Schriebe benötigt werden (z.B. Nirnwurz, Ta, usw.) aus der Bank"

--"<<1>> erhalten"
function WritCreater.langWritRewardBoxes () return {
	[1] = "Alchemistengefäß",
	[2] = "Verzaubererkassette",
	[3] = "Versorgerbeutel",
	[4] = "Schmiedetruhe",
	[5] = "Schneidertasche",
	[6] = "Schreinerkästchen",
	[7] = "Lieferung",
}
end


function WritCreater.getTaString()
	return "ta"
end

WritCreater.lang = "de"