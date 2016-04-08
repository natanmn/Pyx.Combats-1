VitalicRanger = {}
VitalicRanger.__index = VitalicRanger
VitalicRanger.Author = "Vitalic"
VitalicRanger.Version = "1.0"

setmetatable(VitalicRanger, {
	__call = function (cls, ...)
	return cls.new(...)
end,
})

function VitalicRanger.new()
	local self = setmetatable({ }, VitalicRanger)
	-- Mode Tick for Combat --
	self.Mode = 0
	--------------------------

---------- Skill ID's -------------------------------------------------
	VitalicRanger.EVASIVE_EXPLOSIVE_SHOT = { 1257, 1116, 1016 }
	VitalicRanger.WILL_OF_THE_WIND = { 1098, 1097, 1096, 1095, 1007 }
	VitalicRanger.CHARGING_WIND = { 1093, 1092, 1091, 1006 }
	VitalicRanger.BLASTING_GUST = { 1126, 1125, 1077 }
	VitalicRanger.EVASIVE_SHOT = { 1253, 1107, 1012 }
	return self
end

--------------------------------------------------------------------------

----------- Monster Count, not really used currently ---------------------
function VitalicRanger:GetMonsterCount()
	local monsters = GetMonsters()
	local monsterCount = 0

	for k, v in pairs(monsters) do
		if v.IsAggro then
			monsterCount = monsterCount + 1
		end

		self.Mode = 0

		if self.Mode == 0 then
			self.Mode = 1
		end
	end

	return monsterCount
end

------------------------------------------------------------------------------

-------- Roaming? If we are, reset pull tick ---------------------------------

function VitalicRanger:Roaming()
	local selfPlayer = GetSelfPlayer()
	if not selfPlayer then
		return
	end

	if self.Mode == 0 then
		self.Mode = 1
	end
end

---------------------------------------------------------------------------------

-------------- Main Combat Logic --------------------------------------------------

function VitalicRanger:Attack(monsterActor)
	local EVASIVE_EXPLOSIVE_SHOT = SkillsHelper.GetKnownSkillId(VitalicRanger.EVASIVE_EXPLOSIVE_SHOT)
	local WILL_OF_THE_WIND = SkillsHelper.GetKnownSkillId(VitalicRanger.WILL_OF_THE_WIND)
	local CHARGING_WIND = SkillsHelper.GetKnownSkillId(VitalicRanger.CHARGING_WIND)
	local BLASTING_GUST = SkillsHelper.GetKnownSkillId(VitalicRanger.BLASTING_GUST)
	local EVASIVE_SHOT = SkillsHelper.GetKnownSkillId(VitalicRanger.EVASIVE_SHOT)

	local selfPlayer = GetSelfPlayer()
	local actorPosition = monsterActor.Position
	
------- Mob Find ----------------------------------------------------------------------
	if monsterActor then
		
		if actorPosition.Distance3DFromMe > monsterActor.BodySize + 1400 then
			Navigator.MoveTo(actorPosition)
		else
			Navigator.Stop()
----------------------------------------------------------------------------------------

----------------------- If we are stuck casting a charge ability, fix it ----------------
			if selfPlayer:CheckCurrentAction("BT_skill_WindblowShot_Ing") then
				print("Launch Blasting Gust!")
				if BLASTING_GUST == 1077 then
					selfPlayer:DoActionAtPosition("BT_skill_WindblowShot_Fire", actorPosition, 500)
				elseif BLASTING_GUST == 1125 then
					selfPlayer:DoActionAtPosition("BT_skill_WindblowShot_Fire_UP", actorPosition, 500)
				else
					selfPlayer:DoActionAtPosition("BT_skill_WindblowShot_Fire_UP2", actorPosition, 500)
				end

				return
			end

			if selfPlayer.IsActionPending then
				return
			end

-----------------------------------------------------------------------------------------------

------------------------------- PULL: CHARGING WIND ---------------------------------------------

			if self.Mode == 1 and CHARGING_WIND ~= 0 and actorPosition.Distance3DFromMe < monsterActor.BodySize + 1500  then
				print("Pulling!")
				selfPlayer:UseSkillAtPosition(CHARGING_WIND, actorPosition, 1000)
				self.Mode = 0
				return
			end

----------------------------------------------------------------------------------------------------------

-------------------- Set tick to 10 after casting first half of EES, then launch arrows! ------------------
			if self.Mode == 10 then
				print("Launching EES Shot!")
				self.Mode = 0
				selfPlayer:DoActionAtPosition("BT_Attack_JumpShot_Faster", actorPosition, 1000)
				return
			end

------------------------------------------------------------------------------------------------------------

-------------------------------------- KITE: EES + WILL OF THE WIND -----------------------------------------------------------

			if actorPosition.Distance3DFromMe <= monsterActor.BodySize + 450 and EVASIVE_EXPLOSIVE_SHOT ~= 0 and SkillsHelper.IsSkillUsable(EVASIVE_EXPLOSIVE_SHOT)
			and selfPlayer.ManaPercent > 60 then
				print("Target too Close! Casting Will of the Wind + EES")
				local rnd = math.random(1,2)
				local ability = "BT_STOP_ATTACK_R_SC_MultiShot_START"

				if rnd == 2 then
					ability = "BT_STOP_ATTACK_L_SC_MultiShot_START"
				end

				selfPlayer:DoActionAtPosition("BT_skill_MultiShot_UP3", actorPosition, 0)
				selfPlayer:DoActionAtPosition(ability, actorPosition, 900)

				if EVASIVE_EXPLOSIVE_SHOT ~= 0 then
					print("EES!")
					local direction = { "", "_L", "_R" }
					local rnd = math.random(1,3)
					local skillUp = ""

					if EVASIVE_EXPLOSIVE_SHOT == 1116 then
						skillUp = "_UP"
					elseif EVASIVE_EXPLOSIVE_SHOT == 1257 then
						skillUP = "_UP2"
					end

					selfPlayer:DoActionAtPosition("BT_skill_TurnArrow" .. direction[rnd] .. skillUp, actorPosition, 500)
					self.Mode = 10					
					return
				end
				return
			end

------------------------------------------------------------------------------------------------------------------------

-------------------------------- MAIN ABILITY: BLASTING GUST SPAM -------------------------------------------------------

			-- Blasting Gust
			if selfPlayer.ManaPercent > 20 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1500 then
				local rnd = math.random(1,2)
				local ability = "BT_STOP_ATTACK_R_SC_WIND_COOL_START"

				if rnd == 2 then
					ability = "BT_STOP_ATTACK_L_SC_WIND_COOL_START"
				end
				print("Blasting Gust Spam!")
				selfPlayer:DoActionAtPosition(ability, actorPosition, 600)
				if rnd == 1 then
					selfPlayer:DoActionAtPosition("BT_STOP_ATTACK_R_SC_WIND_SHOT", actorPosition, 600)
				elseif rnd == 2 then
					selfPlayer:DoActionAtPosition("BT_STOP_ATTACK_L_SC_WIND_SHOT", actorPosition, 600)
				end
				return
			end

--------------------------------------------------------------------------------------------------------------------------

--------------------------------------------- MANA REGAIN: EVASIVE SHOT SPAM --------------------------------------------

			if selfPlayer.ManaPercent < 20 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 1300 then
				print("Regaining MP, Evasive Shot Spam!")
                local rnd = math.random(1, 2)
                local ability = "BT_STOP_ATTACK_R_START"

                if rnd == 1 then
                    ability = "BT_STOP_ATTACK_L_START"
                end

                if EVASIVE_SHOT == 1012 then
                    selfPlayer:DoActionAtPosition(ability, actorPosition, 600)
                elseif EVASIVE_SHOT == 1107 then
                    selfPlayer:DoActionAtPosition(ability .. "_UP", actorPosition, 600)
                elseif EVASIVE_SHOT == 1253 then
                    selfPlayer:DoActionAtPosition(ability .. "_UP2", actorPosition, 600)
                end
                self.CombatTimer:Reset()
                return
            end

---------------------------------------------------------------------------------------------------------------------------

		end
	end
end

return VitalicRanger()






