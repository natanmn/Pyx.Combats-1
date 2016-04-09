VitalicMage = { }
VitalicMage.__index = VitalicMage
VitalicMage.Version = "1.0"
VitalicMage.Author = "Vitalic"

------------------ Spell ID's -----------------------

VitalicMage.BLIZZARD = { 845, 844, 843 }
VitalicMage.CONCENTRATED_MAGIC_ARROW = { 889, 888, 887 }
VitalicMage.DAGGER_STAB = { 897, 896, 895, 894 }
VitalicMage.EARTHQUAKE = { 789, 788, 787, 786 }
VitalicMage.FIREBALL_EXPLOSION = { 849, 848, 847 }
VitalicMage.FIREBALL = { 821, 820, 819, 818 }
VitalicMage.FREEZE = { 838, 837, 836, 836, 835, 834 }
VitalicMage.FRIGID_FOG = { 842, 841, 840, 839 }
VitalicMage.HEALING_AURA = { 903, 902, 901, 900, 899 }
VitalicMage.LIGHTNING_CHAIN = { 830, 829, 828, 827 }
VitalicMage.LIGHTNING = { 826, 825, 824, 823, 822 }
VitalicMage.LIGHTNING_STORM = { 833, 832, 831 }
VitalicMage.MAGIC_ARROW = { 854, 853, 852, 851, 850 }
VitalicMage.MAGIC_LIGHTHOUSE = { 1622, 1621, 1620 }
VitalicMage.MAGIC_POWER_BOOST = { 817 }
VitalicMage.MAGICAL_EVASION = { 876, 875, 874, 873, 872 }
VitalicMage.MAGICAL_SHIELD = { 871, 870, 869, 868 }
VitalicMage.MANA_ABSORPTION = { 867, 866, 865 }
VitalicMage.METEOR_SHOWER = { 792, 791, 790 }
VitalicMage.MULTIPLE_MAGIC_ARROWS = { 855 }
VitalicMage.RESIDUAL_LIGHTNING = { 859, 858, 857 }

------------------------------------------------------------

setmetatable(VitalicMage, {
	__call = function (cls, ...)
	return cls.new(...)
end,
})

---------------------------------------------------------------

------------------ Setup New Mage and Constants ---------------------

function VitalicMage.new()
	local instance = {}
	local self = setmetatable(instance, VitalicMage)
	return self
end

---------------------------------------------------------------------

function VitalicMage:Roaming()
	local HEALING_AURA = SkillsHelper.GetKnownSkillId(VitalicMage.HEALING_AURA)
	local selfPlayer = GetSelfPlayer()


	if not selfPlayer then
		return
	end

	selfPlayer:CheckFireballStuck("Roaming")

	-- Health low?
	if HEALING_AURA ~= 0 and not selfPlayer:IsSkillOnCooldown(HEALING_AURA) and selfPlayer.ManaPercent > 10 and selfPlayer.HealthPercent < 60
	then
		print("Health Low! Casting Healing Aura!")
		selfPlayer:SetActionState(ACTION_FLAG_SPECIAL_ACTION_2)
		return
	end

end

----------------- Fireball Stuck again? -------------------------------

function VitalicMage:CheckFireballStuck(state)
    local selfPlayer = GetSelfPlayer()
    if selfPlayer:CheckCurrentAction("BT_Skill_Fireball_Ing") then
        print("Fireball Combo Broken in ".. state)
        player:DoActionAtPosition("BT_Skill_Fireball_Shot", selfPlayer.Position, 500)
        return
    end
end

----------------- Main Combat Logic ---------------------------------

function VitalicMage:Attack(monsterActor)

--------------------------- Create Local Skill ID's ---------------------------------------------

	local BLIZZARD = SkillsHelper.GetKnownSkillId(VitalicMage.BLIZZARD)
	local CONCENTRATED_MAGIC_ARROW = SkillsHelper.GetKnownSkillId(VitalicMage.CONCENTRATED_MAGIC_ARROW)
	local DAGGER_STAB = SkillsHelper.GetKnownSkillId(VitalicMage.DAGGER_STAB)
	local EARTHQUAKE = SkillsHelper.GetKnownSkillId(VitalicMage.EARTHQUAKE)
	local FIREBALL_EXPLOSION = SkillsHelper.GetKnownSkillId(VitalicMage.FIREBALL_EXPLOSION)
	local FIREBALL = SkillsHelper.GetKnownSkillId(VitalicMage.FIREBALL)
	local FREEZE = SkillsHelper.GetKnownSkillId(VitalicMage.FREEZE)
	local FRIGID_FOG = SkillsHelper.GetKnownSkillId(VitalicMage.FRIGID_FOG)
	local HEALING_AURA = SkillsHelper.GetKnownSkillId(VitalicMage.HEALING_AURA)
	local LIGHTNING_CHAIN = SkillsHelper.GetKnownSkillId(VitalicMage.LIGHTNING_CHAIN)
	local LIGHTNING = SkillsHelper.GetKnownSkillId(VitalicMage.LIGHTNING)
	local LIGHTNING_STORM = SkillsHelper.GetKnownSkillId(VitalicMage.LIGHTNING_STORM)
	local MAGIC_ARROW = SkillsHelper.GetKnownSkillId(VitalicMage.MAGIC_ARROW)
	local MAGIC_LIGHTHOUSE = SkillsHelper.GetKnownSkillId(VitalicMage.MAGIC_LIGHTHOUSE)
	local MAGIC_POWER_BOOST = SkillsHelper.GetKnownSkillId(VitalicMage.MAGIC_POWER_BOOST)
	local MAGICAL_EVASION = SkillsHelper.GetKnownSkillId(VitalicMage.MAGICAL_EVASION)
	local MAGICAL_SHIELD = SkillsHelper.GetKnownSkillId(VitalicMage.MAGICAL_SHIELD)
	local MANA_ABSORPTION = SkillsHelper.GetKnownSkillId(VitalicMage.MANA_ABSORPTION)
	local METEOR_SHOWER = SkillsHelper.GetKnownSkillId(VitalicMage.METEOR_SHOWER)
	local MULTIPLE_MAGIC_ARROWS = SkillsHelper.GetKnownSkillId(VitalicMage.MULTIPLE_MAGIC_ARROWS)
	local RESIDUAL_LIGHTNING = SkillsHelper.GetKnownSkillId(VitalicMage.RESIDUAL_LIGHTNING)

------------------------------------------------------------------------------------------------------

	local monsters = GetMonsters()
	local monsterCount = 0

	for k, v in pairs(monsters) do
		if v.IsAggro then
			monsterCount = monsterCount + 1
		end
	end

	if monsterActor then

		local selfPlayer = GetSelfPlayer()
		local actorPosition = monsterActor.Position

		if actorPosition.Distance3DFromMe > monsterActor.BodySize + 1300 then
			Navigator.MoveTo(actorPosition)
		else
			Navigator.Stop()

		-- Cast Fireball
		if FIREBALL ~= 0 and not selfPlayer:IsSkillOnCooldown(FIREBALL) and selfPlayer.ManaPercent > 15
		and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1400 then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, actorPosition, 1200)
			return
		end

		-- Fireball + Fireball Explosion Combo
		if FIREBALL_EXPLOSION ~= 0 and not selfPlayer:IsSkillOnCooldown(FIREBALL_EXPLOSION) and string.match(selfPlayer.CurrentActionName, "Fireball") then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 2000)
			return
		end

		-- Health low?
		if HEALING_AURA ~= 0 and not selfPlayer:IsSkillOnCooldown(HEALING_AURA) and selfPlayer.ManaPercent > 10 and selfPlayer.HealthPercent < 60
		and not selfPlayer:IsSkillOnCooldown(HEALING_AURA) then
			selfPlayer:SetActionState(ACTION_FLAG_SPECIAL_ACTION_2)
			return
		end

		-- Mana Low?
		if MANA_ABSORPTION ~= 0 and selfPlayer.ManaPercent <= 40 and not selfPlayer:IsSkillOnCooldown(MANA_ABSORPTION)
		and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1300 then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_MAIN_ATTACK, actorPosition, 6000)
			return
		end

		-- Magical Shield Buff
		if MAGICAL_SHIELD ~= 0 and not selfPlayer:IsSkillOnCooldown(MAGICAL_SHIELD) and selfPlayer.ManaPercent > 20 and not selfPlayer:HasBuffById(617)
		and selfPlayer.HealthPercent <= 40 then
				selfPlayer:SetActionState(ACTION_FLAG_SPECIAL_ACTION_1)
				return
		end

		-- Cast Lightning
		if LIGHTNING ~= 0 and selfPlayer.ManaPercent >= 15 and (not selfPlayer:IsSkillOnCooldown(LIGHTNING) 
		and not string.match(selfPlayer.CurrentActionName, "Fireball")) and actorPosition.Distance3DFromMe < monsterActor.BodySize + 1400 then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SPECIAL_ACTION_3, actorPosition, 1000)
			return
		end

		-- Lightning + Residual Lightning Combo
		if RESIDUAL_LIGHTNING ~= 0 and not selfPlayer:IsSkillOnCooldown(RESIDUAL_LIGHTNING) and string.match(selfPlayer.CurrentActionName, "Lightning")
		then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 2000)
			return
		end

		-- Too many cooldowns? Fuck it, cast Lighting Chain
		if LIGHTNING_CHAIN ~= 0 and selfPlayer:IsSkillOnCooldown(FIREBALL) and selfPlayer:IsSkillOnCooldown(LIGHTNING)
		and selfPlayer.ManaPercent >= 20 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1300 then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 3000)
			return
		end

		-- Lighting Chain + Lightning Storm Combo
		if LIGHTNING_STORM ~= 0 and not selfPlayer:IsSkillOnCooldown(LIGHTNING_STORM) and selfPlayer.ManaPercent > 25 
		and string.match(selfPlayer.CurrentActionName, "Chain_Lightning") and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1300 then
			selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 1200)
			return
		end

		-- Need a bit of help?
		if MAGIC_LIGHTHOUSE ~= 0 and not selfPlayer:IsSkillOnCooldown(MAGIC_LIGHTHOUSE) and monsterCount >= 2 and selfPlayer.HealthPercent < 50 then
			selfPlayer:DoActionAtPosition(MAGIC_LIGHTHOUSE, actorPosition, 600)
			return
		end

		if BLIZZARD ~= 0 and not selfPlayer:IsSkillOnCooldown(BLIZZARD) and selfPlayer.ManaPercent > 30 and monsterCount >= 3
		and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1400 then
			selfPlayer:DoActionAtPosition(BLIZZARD, actorPosition, 3000)
			return
		end
		
      end

   end
	
end

return VitalicMage()







