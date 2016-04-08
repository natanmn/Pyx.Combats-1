VitalicValk = { }
VitalicValk.__index = VitalicValk
VitalicValk.Version = "1.0"
VitalicValk.Author = "Vitalic"

------------------- Spell ID's --------------------------

VitalicValk.BREATH_OF_ELION = { 764, 763, 762 }
VitalicValk.CELESTIAL_SPEAR = { 775, 768, 767, 766, 765 }
VitalicValk.CHARGING_SLASH = { 749, 748, 747 }
VitalicValk.DIVINE_POWER = { 742, 741, 740, 739 }
VitalicValk.FLURRY_OF_KICKS = { 725, 724, 723 }
VitalicValk.FLYING_KICK = { 728, 727 }
VitalicValk.FORWARD_SLASH = { 1478, 1477, 1476 }
VitalicValk.GLARING_SLASH = { 761, 760, 759, 758, 757 }
VitalicValk.HEAVENS_ECHO = { 746, 745, 744 }
VitalicValk.JUDGEMENT_OF_LIGHT = { 774, 773, 772 }
VitalicValk.JUST_COUNTER = { 722, 721, 720 }
VitalicValk.PUNISHMENT = { 779, 778, 777, 776 }
VitalicValk.RIGHTEOUS_CHARGE = { 752, 751, 750 }
VitalicValk.SEVERING_LIGHT = { 1482, 1481, 1480, 1479 }
VitalicValk.SHARP_LIGHT = { 1493, 1492, 1491, 1490 }
VitalicValk.SHIELD_CHASE = { 738, 737, 736 }
VitalicValk.SHIELD_STRIKE = { 1499, 1498, 1497 }
VitalicValk.SHIELD_THROW = { 1486, 1485 }
VitalicValk.SHINING_DASH = { 731 }
VitalicValk.SIDEWAYS_CUT = { 1489, 1488, 1487 }
VitalicValk.SKYWARD_STRIKE = { 756, 755, 754 }
VitalicValk.SWORD_OF_JUDGEMENT = { 735, 734, 733, 732 }
VitalicValk.FLOW_SHIELD_THROW = { 784 }
VitalicValk.ULTIMATE_DIVINE_POWER = { 743 }
VitalicValk.ULTIMATE_FLURRY_OF_KICKS = { 726 }
VitalicValk.ULTIMATE_PUNISHMENT = { 780 }
VitalicValk.ULTIMATE_RIGHTEOUS_CHARGE = { 753 }
VitalicValk.ULTIMATE_SEVERING_LIGHT = { 1483 }
VitalicValk.ULTIMATE_SHARP_LIGHT = { 771 }
VitalicValk.ULTIMATE_SWORD_OF_JUDGEMENT = { 770 }
VitalicValk.GUARD = { 718 }

---------------------------------------------------------------

setmetatable(VitalicValk, {
	__call = function (cls, ...)
	return cls.new(...)
end,
})

----------------------------------------------------------------

------------------ Setup New Valk and Constants ---------------------

function VitalicValk.new()
	local instance = {}
	local self = setmetatable(instance, VitalicValk)
	return self
end

----------------------------------------------------------------------

--------------------- Get Monster Count -------------------------------

function VitalicValk:GetMonsterCount()
	local monsters = GetMonsters()
	local monsterCount = 0
	for k, v in pairs(monsters) do
		if v.IsAggro then
			monsterCount = monsterCount + 1
		end
	end
	return monsterCount
end

----------------------------------------------------------------------

--------------------- Main Combat Logic ------------------------------

function VitalicValk:Attack(monsterActor)

------------------------- Create Local Skills for Combat ------------------------------------------

	local BREATH_OF_ELION = SkillsHelper.GetKnownSkillId(VitalicValk.BREATH_OF_ELION)
	local CELESTIAL_SPEAR = SkillsHelper.GetKnownSkillId(VitalicValk.CELESTIAL_SPEAR)
	local CHARGING_SLASH = SkillsHelper.GetKnownSkillId(VitalicValk.CHARGING_SLASH)
	local DIVINE_POWER = SkillsHelper.GetKnownSkillId(VitalicValk.DIVINE_POWER)
	local FLURRY_OF_KICKS = SkillsHelper.GetKnownSkillId(VitalicValk.FLURRY_OF_KICKS)
	local FLYING_KICK = SkillsHelper.GetKnownSkillId(VitalicValk.FLYING_KICK)
	local FORWARD_SLASH = SkillsHelper.GetKnownSkillId(VitalicValk.FORWARD_SLASH)
	local GLARING_SLASH = SkillsHelper.GetKnownSkillId(VitalicValk.GLARING_SLASH)
	local HEAVENS_ECHO = SkillsHelper.GetKnownSkillId(VitalicValk.HEAVENS_ECHO)
	local JUDGEMENT_OF_LIGHT = SkillsHelper.GetKnownSkillId(VitalicValk.JUDGEMENT_OF_LIGHT)
	local JUST_COUNTER = SkillsHelper.GetKnownSkillId(VitalicValk.JUST_COUNTER)
	local PUNISHMENT = SkillsHelper.GetKnownSkillId(VitalicValk.PUNISHMENT)
	local RIGHTEOUS_CHARGE = SkillsHelper.GetKnownSkillId(VitalicValk.RIGHTEOUS_CHARGE)
	local SEVERING_LIGHT = SkillsHelper.GetKnownSkillId(VitalicValk.SEVERING_LIGHT)
	local SHARP_LIGHT = SkillsHelper.GetKnownSkillId(VitalicValk.SHARP_LIGHT)
	local SHIELD_CHASE = SkillsHelper.GetKnownSkillId(VitalicValk.SHIELD_CHASE)
	local SHIELD_STRIKE = SkillsHelper.GetKnownSkillId(VitalicValk.SHIELD_STRIKE)
	local SHIELD_THROW = SkillsHelper.GetKnownSkillId(VitalicValk.SHIELD_THROW)
	local SHINING_DASH = SkillsHelper.GetKnownSkillId(VitalicValk.SHINING_DASH)
	local SIDEWAYS_CUT = SkillsHelper.GetKnownSkillId(VitalicValk.SIDEWAYS_CUT)
	local SKYWARD_STRIKE = SkillsHelper.GetKnownSkillId(VitalicValk.SKYWARD_STRIKE)
	local SWORD_OF_JUDGEMENT = SkillsHelper.GetKnownSkillId(VitalicValk.SWORD_OF_JUDGEMENT)
	local FLOW_SHIELD_THROW = SkillsHelper.GetKnownSkillId(VitalicValk.FLOW_SHIELD_THROW)
	local ULTIMATE_DIVINE_POWER = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_DIVINE_POWER)
	local ULTIMATE_FLURRY_OF_KICKS = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_FLURRY_OF_KICKS)
	local ULTIMATE_PUNISHMENT = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_PUNISHMENT)
	local ULTIMATE_RIGHTEOUS_CHARGE = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_RIGHTEOUS_CHARGE)
	local ULTIMATE_SEVERING_LIGHT = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_SEVERING_LIGHT)
	local ULTIMATE_SHARP_LIGHT = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_SHARP_LIGHT)
	local ULTIMATE_SWORD_OF_JUDGEMENT = SkillsHelper.GetKnownSkillId(VitalicValk.ULTIMATE_SWORD_OF_JUDGEMENT)
	local GUARD = SkillsHelper.GetKnownSkillId(VitalicValk.GUARD)


-------------------------------------------------------------------------------------------------------------------

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
		
		if not selfPlayer.IsActionPending then
			-- Low on Health? Heal up!
			if BREATH_OF_ELION ~= 0 and selfPlayer.HealthPercent < 50 and not selfPlayer:IsSkillOnCooldown(BREATH_OF_ELION) and selfPlayer.ManaPercent >= 10 then
				print("Nothing going on and we are low on health! Casting Breath of Elion!")
				selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_2)
				return
			end

			-- Heavens Echo Buff
			if HEAVENS_ECHO ~= 0 and not selfPlayer:IsSkillOnCooldown(HEAVENS_ECHO) and not selfPlayer:HasBuffById(27390) and selfPlayer.ManaPercent >= 10 then
				print("Buffing! Heaven's Echo!")
				selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_1)
				return
			end

			if actorPosition.Distance3DFromMe > monsterActor.BodySize + 150 then
				-- Charge the mob!
				if RIGHTEOUS_CHARGE ~= 0 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 700 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 300
				and not selfPlayer:IsSkillOnCooldown(RIGHTEOUS_CHARGE) and selfPlayer.ManaPercent >= 15 then
				print("Charge Pulling! Righteous Charge!")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_SPECIAL_ACTION_3, actorPosition)

			elseif CELESTIAL_SPEAR ~= 0 and selfPlayer:IsSkillOnCooldown(RIGHTEOUS_CHARGE) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 700
			and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 300 and selfPlayer.ManaPercent >= 15 then
				print("Charge on CD! Using Celestial Spear Pull instead!")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SPECIAL_ACTION_2, actorPosition)
				return
			end

			Navigator.MoveTo(actorPosition)
		else
			Navigator.Stop()

			-- Celestial Spear Check
			if CELESTIAL_SPEAR ~= 0 and not selfPlayer:IsSkillOnCooldown(CELESTIAL_SPEAR) and selfPlayer.ManaPercent >= 20 then
				print("Casting Celestial Spear!")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SPECIAL_ACTION_2, actorPosition)
				return
			end

			-- Sword of Judgement
			if SWORD_OF_JUDGEMENT ~= 0 and (not selfPlayer:IsSkillOnCooldown(SWORD_OF_JUDGEMENT) or string.match(selfPlayer.CurrentActionName, "FrontSlice"))
			and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 and selfPlayer.ManaPercent >= 20 then
				print("Sword of Judgment Spam!")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 1000)
				return
			end

			-- Breath of Elion Check
			if BREATH_OF_ELION ~= 0 and (not selfPlayer:IsSkillOnCooldown(BREATH_OF_ELION) or string.match(selfPlayer.CurrentActionName, "RotationBash"))
			and selfPlayer.HealthPercent <= 50 and selfPlayer.ManaPercent >= 15 then
				print("Health is low! Casting Breaht of Elion")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_2)
				return
			end

			-- Shield Throw
			if SHIELD_THROW ~= 0 and (not selfPlayer:IsSkillOnCooldown(SHIELD_THROW) or string.match(selfPlayer.CurrentActionName, "RotationBash")
			or string.match(selfPlayer.CurrentActionName, "FrontSlice") or string.match(selfPlayer.CurrentActionName, "HeavenSpear")) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 600 and selfPlayer.ManaPercent >= 15 then
				print("Throwing Shield!")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SPECIAL_ACTION_1, actorPosition)
				return
			end

			-- Flow: Shield Throw
			if FLOW_SHIELD_THROW ~= 0 and not selfPlayer:IsSkillOnCooldown(FLOW_SHIELD_THROW) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 600 then
				if string.match(selfPlayer.CurrentActionName, "ShieldThrow") then
					print("Flow: Shield throw!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 1750)
					return
				end
			end

			-- Judgement of Light on several adds
			if JUDGEMENT_OF_LIGHT ~= 0 and not selfPlayer:IsSkillOnCooldown(JUDGEMENT_OF_LIGHT) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 500
			and monsterCount >= 3 and selfPlayer.BlackRage == 100 and selfPlayer.ManaPercent >= 30 then
				print("Maximum Black Rage and too many adds! Let their be light!")
				selfPlayer:DoActionAtPosition(JUDGEMENT_OF_LIGHT, actorPosition, 3000)
				return
			end

			-- Mana low? Lets regain that shit!
			if FORWARD_SLASH ~= 0 and (not selfPlayer:IsSkillOnCooldown(FORWARD_SLASH) or string.match(selfPlayer.CurrentActionName, "RotationBash")
			or string.match(selfPlayer.CurrentActionName, "HeavenSpear") or string.match(selfPlayer.CurrentActionName, "ShieldThrow"))
			and selfPlayer.ManaPercent < 20 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 then
				print("Mana Low! Using Forward Slash to regain!")
				selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_MAIN_ATTACK, actorPosition)
				return
			end
      
  		end

	end

  end

end

return VitalicValk()







