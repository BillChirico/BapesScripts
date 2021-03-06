-- Created By Bapes#1111 --
-- Please do not distrubute without consent --

---@diagnostic disable: undefined-global, lowercase-global
local Tinkr, UI = ...
local name = "Bapes BM Rotation"
local version = "v1.2"
local Routine = Tinkr.Routine
local player = "player"
local target = "target"
local pet = "pet"

-- Print name and version
print("|cFFFFD700[Bapes Scripts]|cFF8A2BE2 " .. name .. " " .. version)

Routine:RegisterRoutine(function()
    if gcd() > latency() then
        return
    end

    if not latencyCheck() then
        return
    end

    -- COMBAT --
    local function do_combat()
        -- SETTINGS --

        local mendPetInCombat = UI.config.read("mendPetInCombat", "true")
        local mendPetPercentage = UI.config.read("mendPetPercentage", 40)
        local useTraps = UI.config.read("useTraps", "true")
        local useSerpentSting = UI.config.read("useSerpentSting", "false")
        local useHuntersMark = UI.config.read("useHuntersMark", "true")
        local useMultiShot = UI.config.read("useMultiShot", "true")

        -- END SETTINGS --

        -- SPELLS --

        local mendPet = highestrank(136)

        local rapidFire = highestrank(36828)
        local intimidation = highestrank(19577)
        local bestialWrath = highestrank(19574)

        local autoShot = highestrank(75)
        local huntersMark = highestrank(1130)
        local concussiveShot = highestrank(5116)
        local snakeTrap = highestrank(34600)
        local explosiveTrap = highestrank(13813)
        local misdirection = highestrank(34477)
        local raptorStrike = highestrank(32915)
        local mongooseBite = highestrank(1495)
        local steadyShot = highestrank(34120)
        local killCommand = highestrank(34026)
        local multiShot = highestrank(2643)
        local serpentSting = highestrank(1978)

        -- END SPELLS --

        -- HEALING --

        -- Mend Pet
        if mendPetInCombat and not UnitIsDeadOrGhost(pet) and IsPetActive() then
            if health(pet) <= mendPetPercentage and not buff(mendPet, pet) and castable(mendPet, pet) then
                return cast(mendPet, pet)
            end
        end

        -- END HEALING --

        -- BUFFS --

        -- Bestial Wrath
        if health(target) > 50 and castable(bestialWrath, player) and not buff(bestialWrath, player) then
            return cast(bestialWrath, player)
        end

        -- Intimidation
        if health(target) > 30 and castable(intimidation, target) then
            return cast(intimidation, target)
        end

        -- Rapid Fire
        if health(target) > 50 and not melee() and castable(rapidFire, player) and not buff(rapidFire, player) then
            return cast(rapidFire, player)
        end

        -- END BUFFS --

        -- ATTACK START --

        if not melee() and castable(autoShot, target) and not IsAutoRepeatSpell(autoShot) then
            return cast(autoShot, target)
        end

        if melee() and not IsPlayerAttacking(target) then
            Eval("StartAttack()", "t")
        end

        if not UnitIsDeadOrGhost(pet) and IsPetActive() then
            if health(pet) > 30 or UnitIsPlayer(target) and enemy(target) then
                Eval("PetAttack()", "t")
            end

            if health(pet) < 20 and not UnitIsPlayer(target) and enemy(target) then
                Eval("PetFollow()", "t")
            end
        end

        -- END ATTACK START --

        -- ROTATION --

        -- Hunter's Mark
        if useHuntersMark and not immune(target, huntersMark) and castable(huntersMark, target) and not debuff(huntersMark, target) then
            return cast(huntersMark, target)
        end

        -- Concussive Shot
        if moving(target) and not melee() and UnitIsUnit(player, "targettarget") and castable(concussiveShot, target) then
            return cast(concussiveShot, target)
        end

        -- Serpent Sting
        if useSerpentSting and castable(serpentSting, target) and not debuff(serpentSting, target) then
            return cast(serpentSting, target)
        end

        -- Traps
        if useTraps and melee() then
            if enemies(target, 20) >= 2 then
                if castable(explosiveTrap, target) then
                    return cast(explosiveTrap, target)
                end
            else
                if castable(snakeTrap, target) then
                    return cast(snakeTrap, target)
                end
            end
        end

        -- Misdirection
        if UnitIsUnit(player, "targettarget") and castable(misdirection, pet) then
            return cast(misdirection, pet)
        end

        -- Kill Command
        if castable(killCommand, target) then
            return cast(killCommand, target)
        end

        -- Multi Shot
        if useMultiShot and enemies(target, 20) >= 2 and castable(multiShot, target) then
            return cast(multiShot, target)
        end

        -- Arcane Shot
        if not castable(Multishot, target) and spellisspell(lastspell(1), AutoShot) and
            spellisspell(lastspell(2), SteadyShot) and castable(ArcaneShot, target) then
            return cast(ArcaneShot, target)
        end

        -- Steady Shot 
        if (spellisspell(lastspell(), autoShot) or not spellisspell(lastspell(), steadyShot)) and castable(steadyShot, target) then
            return cast(steadyShot, target)
        end

        -- Mongoose Bite
        if castable(mongooseBite, target) then
            return cast(mongooseBite, target)
        end

        -- Raptor Strike
        if castable(raptorStrike, target) then
            return cast(raptorStrike, target)
        end

        -- END ROTATION --
    end

    -- RESTING --
    local function do_resting()
        if UnitIsDeadOrGhost(player) or UnitIsDeadOrGhost(target) or IsEatingOrDrinking() then
            return
        end

        -- SETTINGS --

        local aspect = UI.config.read("aspect", "Viper")

        -- END SETTINGS --

        -- SPELLS --

        local aspectViper = highestrank(34074)
        local aspectHawk = highestrank(13165)

        local mendPet = highestrank(136)
        local revivePet = highestrank(982)
        local callPet = highestrank(883)

        -- END SPELLS --

        -- PET --

        -- Revive Pet
        if UnitIsDeadOrGhost(pet) and castable(revivePet) then
            return cast(revivePet, player)
        end

        -- Call Pet
        if not IsPetActive() and castable(callPet, player) then
            return cast(callPet, player)
        end

        -- END PET --

        -- HEALING --

        -- Mend Pet
        if not UnitIsDeadOrGhost(pet) and IsPetActive() then
            if health(pet) < 90 and not buff(mendPet, pet) and castable(mendPet, pet) then
                return cast(mendPet, pet)
            end
        end

        -- END HEALING --

        -- BUFFS --

        -- Feed Pet
        local FeedPet_cd = 0
        local needsFeeding = ({true, true})[GetPetHappiness()]
        if needsFeeding and not UnitIsDeadOrGhost(pet) and IsPetActive() and not buff(1539, pet) and castable(FeedPet, pet) and FeedPet_cd < GetTime() then
            FeedPet_cd = GetTime() + 4
            return Eval('RunMacroText("' .. "/click FOM_FeedButton" .. '")', "something")
        end
        
        -- Aspect
        if aspect == "Viper" and castable(aspectViper, player) and not buff(aspectViper, player) then
            return cast(aspectViper, player)
        else
            if aspect == "Hawk" and castable(aspectHawk, player) and not buff(aspectHawk, player) then
                return cast(aspectHawk, player)
            end
        end

        -- END BUFFS --

        -- Pet Attack
        if UnitExists(target) and alive(target) and enemy(target) and distance(player, target) <= math.random(35, 45) then
            Eval("PetAttack()", "t")
        end
    end

    if combat(player) then
        do_combat()
        return
    else
        do_resting()
        return
    end

end, Routine.Classes.Hunter, "bapes-bm")
Routine:LoadRoutine("bapes-bm")

local bapesBM_settings = {
    key = "bapes_bm_config",
    title = "Bapes Scripts",
    width = 400,
    height = 300,
    color = "F58CBA",
    resize = false,
    show = false,
    table = {
        {
            key = "heading",
            type = "heading",
            text = name .. " " .. version
        },
        -- Healing --
        {
            key = "heading",
            type = "heading",
            text = "Healing"
        },
        -- Mend Pet in Combat
        {
            key = "mendPetInCombat",
            type = "checkbox",
            text = "Mend Pet in Combat"
        },
        -- Mend Pet Percentage
        {
            key = "mendPetPercentage",
            type = "slider",
            text = "Mend Pet Percentage",
            label = "Mend Pet %",
            min = 5,
            max = 95,
            step = 5
        },
        -- Buffs --
        {
            key = "heading",
            type = "heading",
            text = "Buffs"
        },
        -- Aspect
        {
            key = "aspect",
            width = 130,
            label = "Aspect",
            type = "dropdown",
            options = {"Viper", "Hawk"}
        },
        -- Combat Options --
        {
            key = "heading",
            type = "heading",
            text = "Combat Options"
        },
        -- Use Traps
        {
            key = "useTraps",
            type = "checkbox",
            text = "Use Traps"
        },
        -- Use Serpent Sting
        {
            key = "useSerpentSting",
            type = "checkbox",
            text = "Use Serpent Sting"
        },
        -- Use Hunters Mark
        {
            key = "useHuntersMark",
            type = "checkbox",
            text = "Use Hunter's Mark"
        },
        -- Use Multi-shot
        {
            key = "useMultiShot",
            type = "checkbox",
            text = "Use Multi-shot"
        }
    }
}

UI.build_rotation_gui(bapesBM_settings)

local bapesBM_buttons = {}

UI.button_factory(bapesBM_buttons)