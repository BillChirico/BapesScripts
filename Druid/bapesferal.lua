-- Created By Bapes#1111 --
-- Please do not distrubute without consent --

---@diagnostic disable: undefined-global, lowercase-global
local Tinkr = ...
local wowex = {}
local name = "Bapes Feral Rotation"
local version = "v1.3"
local Routine = Tinkr.Routine
local Draw = Tinkr.Util.Draw:New()
local player = "player"
local target = "target"

-- CROMULON IMPORTS --

Tinkr:require("scripts.cromulon.libs.Libdraw.Libs.LibStub.LibStub", wowex)
Tinkr:require("scripts.cromulon.libs.Libdraw.LibDraw", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.AceGUI30", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-BlizOptionsGroup", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-DropDownGroup", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Frame", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-InlineGroup", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-ScrollFrame", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-SimpleGroup", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TabGroup", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-TreeGroup", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIContainer-Window", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Button", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-CheckBox", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-ColorPicker", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-DropDown-Items", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-EditBox", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Heading", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Icon", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-InteractiveLabel", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Keybinding", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Label", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-MultiLineEditBox", wowex)
Tinkr:require("scripts.cromulon.libs.AceGUI30.widgets.AceGUIWidget-Slider", wowex)
Tinkr:require("scripts.cromulon.system.configs", wowex)
Tinkr:require("scripts.wowex.libs.AceAddon30.AceAddon30", wowex)
Tinkr:require("scripts.wowex.libs.AceConsole30.AceConsole30", wowex)
Tinkr:require("scripts.wowex.libs.AceDB30.AceDB30", wowex)
Tinkr:require("scripts.cromulon.system.storage", wowex)
Tinkr:require("scripts.cromulon.libs.libCh0tFqRg.libCh0tFqRg", wowex)
Tinkr:require("scripts.cromulon.libs.libNekSv2Ip.libNekSv2Ip", wowex)
Tinkr:require("scripts.cromulon.libs.CallbackHandler10.CallbackHandler10", wowex)
Tinkr:require("scripts.cromulon.libs.HereBeDragons.HereBeDragons-20", wowex)
Tinkr:require("scripts.cromulon.libs.HereBeDragons.HereBeDragons-pins-20", wowex)
Tinkr:require("scripts.cromulon.interface.uibuilder", wowex)
Tinkr:require("scripts.cromulon.interface.buttons", wowex)
Tinkr:require("scripts.cromulon.interface.panels", wowex)
Tinkr:require("scripts.cromulon.interface.minimap", wowex)
mybuttons.On = false
mybuttons.Cooldowns = false
mybuttons.MultiTarget = false
mybuttons.Interupts = false
mybuttons.Settings = false

-- END CROMULON IMPORTS --

-- Print name and version
print("|cFFFFD700[Bapes Scripts]|cFF8A2BE2 " .. name .. " " .. version)

Routine:RegisterRoutine(function()
	if gcd() > latency() then
		return
	end

	if not latencyCheck() then
		return
	end

	local function manacost(spellname)
		if not spellname then
			return 0
		else
			local costTable = GetSpellPowerCost(spellname)
			if costTable == nil then
				return 0
			end
			for _, costInfo in pairs(costTable) do
				if costInfo.type == 0 then
					return costInfo.cost
				end
			end
		end
	end

	-- COMBAT --
	local function do_combat()
		local mana = power()
		local comboPoints = GetComboPoints(player, target)
		local rage = power(PowerType.Rage)

		-- SETTINGS --

		local healInCombat = wowex.config.read("healInCombat", "true")
		local healPercentage = wowex.config.read("healPercentage", 40)

		local useInnervate = wowex.config.read("useInnervate", "false")

		local usePowershift = wowex.config.read("usePowershift", "false")

		local useBearForm = wowex.config.read("useBearForm", "true")
		local bearFormPercentage = wowex.config.read("bearFormPercentage", 50)

		-- END SETTINGS --

		-- SPELLS --

		local catForm = highestrank(768)
		local bearForm = highestrank(5487)

		-- Dire Bear
		if not bearForm then
			bearForm = highestrank(9634)
		end

		local barkSkin = highestrank(22812)
		local regrowth = highestrank(8936)
		local rejuvenation = highestrank(774)

		local innervate = highestrank(29166)
		local faerieFire = highestrank(16857)

		-- Cat
		local rake = highestrank(1822)
		local mangle = highestrank(33876)
		local rip = highestrank(1079)
		local ferociousBite = highestrank(22568)
		local shred = highestrank(5221)

		-- Bear
		local frenziedRegeneration = highestrank(22842)
		local lacerate = highestrank(33745)
		local maul = highestrank(6807)
		local bearMangle = highestrank(33878)
		local bash = highestrank(5211)
		local feralCharge = highestrank(16979)

		-- END SPELLS --

		-- Auto Attack
		if UnitExists(target) and not UnitIsDeadOrGhost(target) and enemy(target) then
			Eval("StartAttack()", "t")
		end

		-- HEALING --

		if healInCombat and not buff(frenziedRegeneration) then
			if health() <= healPercentage and castable(barkSkin, player) then
				return cast(barkSkin, player)
			end

			if health() <= healPercentage and castable(rejuvenation, player) and not buff(rejuvenation, player) then
				return cast(rejuvenation, player)
			end

			if health() <= healPercentage and castable(regrowth, player) and not buff(regrowth, player) then
				return cast(regrowth, player)
			end
		end

		-- END HEALING --

		-- BUFFS --

		if mana <= 45 and castable(innervate, player) and useInnervate then
			return cast(innervate, player)
		end

		-- Bear Form
		if
			useBearForm
			and health() <= bearFormPercentage
			and not buff(bearForm, player)
			and castable(bearForm, player)
		then
			return cast(bearForm, player)
		else
			-- Cat Form
			if not buff(catForm, player) and castable(catForm, player) then
				return cast(catForm, player)
			end
		end

		-- END BUFFS --

		-- DEBUFFS --

		if not debuff(faerieFire, target) then
			return cast(faerieFire, target)
		end

		-- END DEBUFFS --

		-- CAT ROTATION --

		if buff(catForm, player) then
			-- Power Shift
			if usePowershift and power() <= 8 and power() >= manacost("Cat Form") then
				Eval('RunMacroText("/return cast !Cat Form")', "r")
			end

			-- Rake
			if not debuff(rake, target) and comboPoints < 5 and castable(rake, target) then
				return cast(rake, target)
			end

			-- Mangle Spam
			if comboPoints < 5 and castable(mangle, target) then
				return cast(mangle, target)
			end

			-- Rip
			if health(target) >= 40 and comboPoints >= 4 and castable(rip, target) then
				return cast(rip, target)
			else
				-- Ferocious Bite
				if comboPoints >= 5 and castable(ferociousBite, target) then
					return cast(ferociousBite, target)
				end
			end

			-- Shred with Clearcasting
			if castable(shred, target) and buff(16870, player) then
				return cast(shred, target)
			end
		end

		-- END CAT ROTATION --

		-- BEAR ROTATION --

		if buff(bearForm, player) then
			-- Frenzied Regeneration
			if health() <= 35 and castable(frenziedRegeneration, player) then
				return cast(frenziedRegeneration, player)
			end

			-- Frenzied Regeneration is still going so don't use abilities
			if buff(frenziedRegeneration, player) then
				return
			end

			-- Feral Charge
			if UnitExists(target) and spellInRange(feralCharge) and castable(feralCharge, target) then
				return cast(feralCharge, target)
			end

			-- Bash
			if castable(bash, target) then
				return cast(bash, target)
			end

			if rage < 75 then
				-- Lacerate
				if castable(lacerate, target) then
					return cast(lacerate, target)
				end
			else
				-- Maul
				if castable(maul, target) then
					return cast(maul, target)
				end
			end

			-- Mangle Spam
			if castable(bearMangle, target) then
				return cast(bearMangle, target)
			end
		end

		-- END BEAR ROTATION --
	end

	-- RESTING --
	local function do_resting()
		if UnitIsDeadOrGhost(player) or UnitIsDeadOrGhost(target) or IsEatingOrDrinking() then
			return
		end

		-- SETTINGS --

		local healOutOfCombat = wowex.config.read("healOutOfCombat", "true")
		local healPercentage = wowex.config.read("healPercentage", 40)

		-- END SETTINGS --

		-- SPELLS --

		local catForm = highestrank(768)

		local regrowth = highestrank(8936)
		local rejuvenation = highestrank(774)
		local healingTouch = highestrank(5185)

		local omenOfClarity = highestrank(16864)

		local stealth = highestrank(5215)
		local dash = highestrank(1850)
		local pounce = highestrank(9005)

		-- MOTW Ranks
		local motwRanks = {
			21849,
			21850,
			26991,
			1126,
			5232,
			8907,
			9884,
			9885,
			26990,
		}

		-- Thorns Ranks
		local thornsRanks = { 467, 782, 1075, 8914, 9756, 9910, 26992 }

		-- END SPELLS --

		-- HEALING --

		if healOutOfCombat then
			if health() <= healPercentage and castable(rejuvenation) and not buff(rejuvenation, player) then
				return cast(rejuvenation, player)
			end

			if health() <= healPercentage and castable(regrowth) and not buff(regrowth, player) then
				return cast(regrowth, player)
			end

			if health() <= healPercentage and castable(healingTouch) and not buff(healingTouch, player) then
				return cast(healingTouch, player)
			end
		end

		-- END HEALING --

		-- BUFFS --

		-- MOTW (Check for GOTW & all ranks)
		if castable(MarkOfTheWild, player) and not buff(MarkOfTheWild, player) and not buff(GiftOfTheWild, player) then
			for _, motwRank in pairs(motwRanks) do
				if buff(motwRank, player) then
					break
				end
			end

			return cast(MarkOfTheWild, player)
		end

		-- Thorns (Check for all ranks)
		if castable(Thorns, player) and not buff(Thorns, player) then
			for _, thornRank in pairs(thornsRanks) do
				if buff(thornRank, player) then
					break
				end
			end

			return cast(Thorns, player)
		end

		-- Omen of Clarity
		if castable(omenOfClarity, player) and not buff(omenOfClarity, player) then
			return cast(omenOfClarity, player)
		end

		-- END BUFFS --

		-- Cat Form
		if
			UnitExists(target)
			and alive(target)
			and not buff(catForm, player)
			and castable(catForm, player)
			and distance(player, target) <= math.random(25, 40)
		then
			return cast(catForm, player)
		end

		-- Stealth
		if
			wowex.wowexStorage.read("useStealth")
			and UnitExists(target)
			and alive(target)
			and not buff(stealth, player)
			and castable(stealth, player)
			and distance(player, target) <= 15
		then
			return cast(stealth, player)
		end

		-- Dash
		if not buff(dash, player) and castable(dash, player) then
			return cast(dash, player)
		end

		-- Pounce
		if UnitExists(target) and spellInRange(pounce) and castable(pounce, target) then
			return cast(pounce, target)
		end
	end

	if combat(player) then
		do_combat()
		return
	else
		do_resting()
		return
	end
end, Routine.Classes.Drwowexd, "bapes-feral")
Routine:LoadRoutine("bapes-feral")

local bapesFeral_buttons = {
	{
		key = "useProwl",
		buttonname = "useProwl",
		texture = "ability_ambush",
		tooltip = "Prowl",
		text = "Prowl",
		setx = "TOP",
		parent = "settings",
		sety = "TOPRIGHT",
	},
}

wowex.button_factory(bapesFeral_buttons)

Draw:Enable()

local bapesFeralTable = {
	key = "bapes_feral_config",
	name = "Bapes Feral Druid Rotation",
	height = "400",
	width = "600",
	panels = {
		{
			name = "healing",
			items = {
				{
					key = "healInCombat",
					type = "checkbox",
					text = "Heal in Combat",
					desc = "On / Off",
				},
				{
					key = "healOutOfCombat",
					type = "checkbox",
					text = "Heal out of Combat",
					desc = "On / Off",
				},
				{
					key = "healPercentage",
					type = "slider",
					text = "Healing Percentage",
					label = "Healing %",
					min = 5,
					max = 95,
					step = 5,
				},
			},
		},
		{
			name = "buffs",
			items = {
				{
					key = "useInnervate",
					type = "checkbox",
					text = "Use Innervate",
					desc = "On / Off",
				},
			},
		},
		{
			name = "defensives",
			items = {
				{
					key = "useBearForm",
					type = "checkbox",
					text = "Use Bear Form",
					desc = "On / Off",
				},
				{
					key = "bearFormPercentage",
					type = "slider",
					text = "Bear Form Percentage",
					label = "Bear Form %",
					min = 5,
					max = 95,
					step = 5,
				},
			},
		},
		{
			name = "combat",
			items = {
				{
					key = "usePowershift",
					type = "checkbox",
					text = "Cat Form Powershift",
					desc = "On / Off",
				},
			},
		},
	},
	tabgroup = {
		{ text = "Healing", value = "one" },
		{ text = "Buffs", value = "two" },
		{ text = "Defensives / Bear Form", value = "three" },
		{ text = "Combat", value = "four" },
	},
}

wowex.createpanels(bapesFeralTable)
