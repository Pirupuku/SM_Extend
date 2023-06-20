function startattack()
	if not AtkSpell then
		for AtkSlot = 1,120 do
			if IsAttackAction(AtkSlot) then
				AtkSpell = AtkSlot
			end
		end
	end
	if not IsCurrentAction(AtkSpell) then
		UseAction(AtkSpell)
	end
end

function startAttack()
	if not PlayerFrame.inCombat then AttackTarget() end
end

function sa2(slot)
	if not IsCurrentAction(slot) then UseAction(slot) end;
end

function stanceDance(stance, ifspell, elsespell)
	local texture,name,isActive,isCastable = GetShapeshiftFormInfo(stance)
	if isActive then CastSpellByName(ifspell) else CastSpellByName(elsespell) end
end

function heroicStrike(value)
	if UnitMana("player") > value then CastSpellByName("Heroic Strike") end
end

function hamstring(amount)
	if UnitMana("player") > amount then CastSpellByName("Hamstring") end
end

function rebuff(spellhere, targetWho)
	if not FindBuff(spellhere, targetWho) then CastSpellByName(spellhere) end
end

function hsqueue()
  local cur = currentMHSwingTime
  local max = totalMHSwingTime
  if (max - cur < 1) and (UnitMana("player") < 75) then
    SpellStopCasting()
  else
    CastSpellByName("Heroic Strike")
  end
end

function mouseoverSpell(spell)
  if UnitExists("mouseover") then
    local switchback = not UnitIsUnit("target", "mouseover")

    TargetUnit("mouseover")
    CastSpellByName(spell)

    if switchback then
      TargetLastTarget()
    end
  else
    CastSpellByName(spell)
  end
end

function StackCast(spell,numstacks)
	--VERY useful function for stacking a certain number of debuffs (example scorch) on a target and then not casting anymore of that.
	--I use it to put 5 scorches on mage targets then move on to fireballs
	--Could also be used for sunder armor
	local spell_icon=GetSpellTexture(SpellNum(spell),BOOKTYPE_SPELL)
	local count,icon
	for i=1,16 do
		icon,count,bufftype,duration,expiration,caster = UnitDebuff("target",i)
		if icon==spell_icon then
		break end
		end
		if not count then count=0 end
		if count<numstacks then
		if count>=numstacks then CooldownCast(spell,20) else cast(spell) end
	end
end

function CooldownCast(spell,cooldown)
	if OnCooldown(spell) then return end
	local time=GetTime()
	if not MB_cooldowns[spell] then
		cast(spell)
		MB_cooldowns[spell]=time
		return
	end
	if MB_cooldowns[spell]+cooldown>time then
		--Print(spell.." is on cooldown for "..math.floor(MB_cooldowns[spell]+cooldown-time).." more seconds")
		return
	end
	if MB_cooldowns[spell]+cooldown<=time then
		cast(spell)
		MB_cooldowns[spell]=nil
	end
end

function SpellNum(spell)
	--In the wonderful world of 1.12 programming, sometimes just using a spell name isn't enough.
	--SOMETIMES you need to know what spell NUMBER it is, cause otherwise it doesn't work.
	--Healthstones and feral spells are like this.
	local i = 1 highestSpellNum=0
	local spellName
	while true do
		spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end
		if string.find(spellName,spell) then highestSpellNum=i end
		i = i + 1
	end
	--Fs* returned the spellid of the last spell in the spellbook if the spell is not in the spellbook
	if highestSpellNum==0 then return end
	--Fs*
	return highestSpellNum
end

function OnCooldown(spell)
	--Important helper function that returns true(actually the duration left) if a spell is on cooldown, nil if not.
	if not SpellExists(spell) then return true end
	local start,duration,enable = GetSpellCooldown(SpellNum(spell),BOOKTYPE_SPELL)
	local restCD = start-GetTime()+duration
	if start == 0 then
		return 0
	else
		if restCD==0 then
			return 0
		else
			return restCD
		end
	end
end

function SpellExists(findspell)
	if not findspell then return end
	for i = 1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
		if not name then break end
		for s = offset + 1, offset + numSpells do
		local	spell, rank = GetSpellName(s, BOOKTYPE_SPELL);
		if rank then
			local spell = spell.." "..rank;
		end
		if string.find(spell,findspell,nil,true) then
			return true
		end
		end
	end
end

function hunterAutoAttack(slotNumber)
	if GetUnitName("target")==nil then TargetNearestEnemy() end
	if CheckInteractDistance("target", 3) and (not PlayerFrame.inCombat) then AttackTarget() elseif not IsAutoRepeatAction(slotNumber) then CastSpellByName("Auto Shot") end
end

function nearestTarget()
	if UnitHealth("target")==0 and UnitExists("target") then ClearTarget(); end
	if GetUnitName("target")==nil then TargetNearestEnemy() end
end

function getMobStats()
	u=UnitResistance y="target" a=u(y ,0) h=u(y ,1) f=u(y ,2) n=u(y ,3) fr=u(y ,4) s=u(y ,5) z=u(y ,6)
	SendChatMessage(UnitName(y).." has "..a.." Armor, "..h.." HR, "..f.." FR, "..n.." NR, "..fr.." FrR, "..s.." SR and "..z.." AR.", SAY)
end

function stealthBasterd(abilityName)
	for i = 1,20 do TargetNearestEnemy() if UnitIsPlayer("target") then return CastSpellByName(abilityName) end end
end

function grpRotation(uniquespellname, grpname)
	if k<4 then k=k+1  else SendChatMessage("Interrupted! -> Next Grp " + grpname,"SAY") k=0 end
	CastSpellByName(uniquespellname)
end

function sunderArmor(rage)
	if rage == nil then
		rage = 0
	end
	if UnitMana("player") > rage then
		KLHTM_Sunder()
	end
end

function showtooltip(spellnameandrank)
	if nil then CastSpellByName(spellnameandrank) end
end

function startWanding(slotCheck)
	if not IsAutoRepeatAction(slotCheck) then CastSpellByName("Shoot") end
end

function HasBuff(unit,buff_name)
    bn=string.lower(buff_name)
    g=GameTooltip g:SetOwner(WorldFrame)
    t=GameTooltipTextLeft1
    for i=1,32 do g:SetUnitBuff(unit,i)
        b=t:GetText()
        g:ClearLines() 
        if b then
            if string.lower(b)==bn then
                g:Hide()
                return true
            end
        end 
    end 
    g:Hide()
    return false
end

function HasDebuff(unit,debuff_name)
    dn=string.lower(debuff_name)
    g=GameTooltip g:SetOwner(WorldFrame)
    t=GameTooltipTextLeft1
    for i=1,16 do g:SetUnitDebuff(unit,i)
        db=t:GetText()
        g:ClearLines() 
        if db then 
            if string.lower(db)==dn then
                g:Hide()
                return true
            end
        end 
    end 
    g:Hide()
    return false
end

function SpellReady(sn)
    local i,a=0
    while a~=sn do 
        i=i+1 
        a=GetSpellName(i,"spell")
    end 
    if GetSpellCooldown(i,"spell") == 0 then 
        return true
    end
end

function swapet(petSpellName)
	local i,g,c=1,0,0
	while GetSpellName(i,"pet") do 
		if GetSpellName(i,"pet")=="Growl" then 
			g=i 
		else
			if GetSpellName(i,"pet")==petSpellName then 
				c=i
			end
		end 
		i=i+1 
	end 
	local _,y = GetSpellAutocast(g,"pet") 
	local _,x = GetSpellAutocast(c,"pet") 
	if (y and x) then 
		ToggleSpellAutocast(g,"pet")
	end
	if (y and (not x)) then 
		ToggleSpellAutocast(g,"pet")
		ToggleSpellAutocast(c,"pet")
	end
	if ((not y) and x) then 
		ToggleSpellAutocast(g,"pet")
		ToggleSpellAutocast(c,"pet")
	end
	if (not y and not x) then 
		ToggleSpellAutocast(c,"pet")
	end
end

function buffLevel(spellNames)
	local c,u,t,s=CastSpellByName,UnitLevel,"target",spellNames.."(Rank " l={1,2,14,26,38,50}
	if (u(t)~=nil and UnitIsFriend("player",t)) then
		for i=6,1,-1 do
			if (u(t)>=l[i]) then c(s..i..")")
				return
			end
		end
	else
		c(spellNames)
	end
end

function petHandling(petFood)
	local c=CastSpellByName
	if UnitExists("pet") then
		if UnitHealth("pet")==0 then
			c("Revive Pet")
		elseif GetPetHappiness()~=nil and GetPetHappiness()~=3 then
			c("Feed Pet") pickup(petFood)
		else
			c("Dismiss Pet")
		end
	else
		c("Call Pet")
	end
end

function fdTrap(trapName)
	local c=CastSpellByName
	c(trapName)
	if UnitAffectingCombat("player") then
		c("Feign Death")
	end
	if UnitExists("pettarget") and CheckInteractDistance("target", 3) and UnitIsUnit("target", "pettarget") then 
		PetPassiveMode()
	end
end

function skeramMark(yourPetName)
	TargetUnit(yourPetName)
	TargetUnit("targettarget")
	if GetRaidTargetIndex("target")==nil then
		SetRaidTargetIcon("target",5) --Raid mark: MOON
	end
end

function pummelShieldbash()
	local _, _, i = strfind((GetInventoryItemLink("player",17) or ""),"(item:%d+:%d+:%d+:%d+)");
	local _, _, _, _, _, s = GetItemInfo((i or 0));
	if (s=="Shields") then
		stanceDance(3,"Defensive Stance","Shield Bash")
	else
		stanceDance(3,"Pummel","Berserker Stance")
	end
end

function basicTotems(whichRoleBasic)
	if whichRoleBasic=="tank" and (not FindBuff("Windfury Totem 3","player")) then
		CastSpellByName("Windfury Totem")
	else
		if whichRoleBasic=="tank" and FindBuff("Strength of Earth","player") and (FindBuff("Mana Spring","player") or FindBuff("Mana Tide","player")) and (not FindBuff("Grace of Air","player")) then
			CastSpellByName("Grace of Air Totem")
		end
	end
	if (whichRoleBasic=="melee" or whichRoleBasic=="dps") and (not FindBuff("Windfury Totem 3","player")) then
		CastSpellByName("Windfury Totem")
	else
		if (whichRoleBasic=="melee" or whichRoleBasic=="dps") and FindBuff("Strength of Earth","player") and (FindBuff("Mana Spring","player") or FindBuff("Mana Tide","player")) and (not FindBuff("Tranquil Air","player")) then
			CastSpellByName("Tranquil Air Totem")
		end
	end
	if (whichRoleBasic=="healer" or whichRoleBasic=="caster") and (not FindBuff("Tranquil Air","player")) then
		CastSpellByName("Tranquil Air Totem")
	end
	if not FindBuff("Mana Spring","player") then
		CastSpellByName("Mana Spring Totem")
	end
	if (whichRoleBasic=="tank" or whichRoleBasic=="melee" or whichRoleBasic=="dps") and not FindBuff("Strength of Earth","player") then	
		CastSpellByName("Strength of Earth Totem")
	end
end

function resistanceTotems(whichResistance,whichRoleResistance)

	--Fire Resistance Totem is a WATER BASED TOTEM
	--Max Rank is III
	if whichResistance=="fire" and (not FindBuff("Fire Resistance","player")) then
		CastSpellByName("Fire Resistance Totem") 
	end
	
	--Frost Resistance Totem is a FIRE BASED TOTEM
	--Max Rank is III
	if whichResistance=="frost" and (not FindBuff("Frost Resistance","player")) then
		CastSpellByName("Frost Resistance Totem")
	end
	
	--Nature Resistance Totem is a AIR BASED TOTEM
	--Max Rank is III
	if whichResistance=="nature" and (not FindBuff("Nature Resistance","player")) then
		CastSpellByName("Nature Resistance Totem")
	end
	
	--TANK
	if whichResistance=="fire" and whichRoleResistance=="tank" and (not FindBuff("Windfury Totem 3","player")) then
		CastSpellByName("Windfury Totem")
	else
		if whichResistance=="fire" and whichRoleResistance=="tank" and FindBuff("Strength of Earth","player") and (not FindBuff("Grace of Air","player")) then
			CastSpellByName("Grace of Air Totem")
		end
	end
	
	if whichResistance=="frost" and whichRoleResistance=="tank" and (not FindBuff("Windfury Totem 3","player")) then
		CastSpellByName("Windfury Totem")
	else
		if whichResistance=="frost" and whichRoleResistance=="tank" and FindBuff("Strength of Earth","player") and (not FindBuff("Mana Spring","player") or not FindBuff("Mana Tide","player")) and (not FindBuff("Grace of Air","player")) then
			CastSpellByName("Grace of Air Totem")
		end
	end
	
	--MELEE/DPS
	if whichResistance=="fire" and (whichRoleResistance=="melee" or whichRoleResistance=="dps") and (not FindBuff("Windfury Totem 3","player")) then
		CastSpellByName("Windfury Totem")
	else
		if whichResistance=="fire" and (whichRoleResistance=="melee" or whichRoleResistance=="dps") and FindBuff("Strength of Earth","player") and (not FindBuff("Tranquil Air","player")) then
			CastSpellByName("Tranquil Air Totem")
		end
	end
	
	if whichResistance=="frost" and (whichRoleResistance=="melee" or whichRoleResistance=="dps") and (not FindBuff("Windfury Totem 3","player")) then
		CastSpellByName("Windfury Totem")
	else
		if whichResistance=="frost" and (whichRoleResistance=="melee" or whichRoleResistance=="dps") and FindBuff("Strength of Earth","player") and (not FindBuff("Mana Spring","player") or not FindBuff("Mana Tide","player")) and (not FindBuff("Tranquil Air","player")) then
			CastSpellByName("Tranquil Air Totem")
		end
	end
	
	--HEALER/CASTER
	if (whichRoleResistance=="healer" or whichRoleResistance=="caster") and (not FindBuff("Tranquil Air","player")) then
		CastSpellByName("Tranquil Air Totem")
	end
	
	--other TOTEMS
	if ((whichResistance=="nature" and FindBuff("Nature Resistance Totem","player")) or (whichResistance=="frost" and FindBuff("Frost Resistance Totem","player"))) and not FindBuff("Mana Spring","player") then
		CastSpellByName("Mana Spring Totem")
	end
	
	if (whichRoleResistance=="tank" or whichRoleResistance=="melee" or whichRoleResistance=="dps") and (not FindBuff("Mana Spring","player") or not FindBuff("Mana Tide","player")) and not FindBuff("Strength of Earth","player") then	
		CastSpellByName("Strength of Earth Totem")
	end
	
end

function dispellTotems(whichDispell,whichRoleDispell)
	local currentTarget
	--POISON totem
	if whichDispell=="poison" and whichRoleDispell=="tank" then
		currentTarget = UnitName("target")
		ClearTarget()
		TargetByName("Poison Cleansing Totem",true)
		if not CheckInteractDistance("target",4) then
			CastSpellByName("Poison Cleansing Totem")
		end
		if not currentTarget then
			ClearTarget()
		else
			TargetByName(currentTarget)
		end
		if not FindBuff("Windfury Totem 3","player") then
			CastSpellByName("Windfury Totem")
		else
			if FindBuff("Strength of Earth","player") and (not FindBuff("Grace of Air","player")) then
				CastSpellByName("Grace of Air Totem")
			end
		end
	end
	if whichDispell=="poison" and (whichRoleDispell=="melee" or whichRoleDispell=="dps") then
		currentTarget = UnitName("target")
		ClearTarget()
		TargetByName("Poison Cleansing Totem",true)
		if not CheckInteractDistance("target",4) then
			CastSpellByName("Poison Cleansing Totem")
		end
		if not currentTarget then
			ClearTarget()
		else
			TargetByName(currentTarget)
		end
		if not FindBuff("Windfury Totem 3","player") then
			CastSpellByName("Windfury Totem")
		else
			if FindBuff("Strength of Earth","player") and (not FindBuff("Tranquil Air","player")) then
				CastSpellByName("Tranquil Air Totem")
			end
		end
	end
	if whichDispell=="poison" and (whichRoleDispell=="healer" or whichRoleDispell=="caster") then
		currentTarget = UnitName("target")
		ClearTarget()
		TargetByName("Poison Cleansing Totem",true)
		if not CheckInteractDistance("target",4) then
			CastSpellByName("Poison Cleansing Totem")
		end
		if not currentTarget then
			ClearTarget()
		else
			TargetByName(currentTarget)
		end
		if not FindBuff("Tranquil Air","player") then
			CastSpellByName("Tranquil Air Totem")
		end
	end
	
	--DISEASE totem
	if whichDispell=="disease" and whichRoleDispell=="tank" then
		currentTarget = UnitName("target")
		ClearTarget()
		TargetByName("Disease Cleansing Totem",true)
		if not CheckInteractDistance("target",4) then
			CastSpellByName("Disease Cleansing Totem")
		end
		if not currentTarget then
			ClearTarget()
		else
			TargetByName(currentTarget)
		end
		if not FindBuff("Windfury Totem 3","player") then
			CastSpellByName("Windfury Totem")
		else
			if FindBuff("Strength of Earth","player") and (not FindBuff("Grace of Air","player")) then
				CastSpellByName("Grace of Air Totem")
			end
		end
	end
	if whichDispell=="disease" and (whichRoleDispell=="melee" or whichRoleDispell=="dps") then
		currentTarget = UnitName("target")
		ClearTarget()
		TargetByName("Disease Cleansing Totem",true)
		if not CheckInteractDistance("target",4) then
			CastSpellByName("Disease Cleansing Totem")
		end
		if not currentTarget then
			ClearTarget()
		else
			TargetByName(currentTarget)
		end
		if not FindBuff("Windfury Totem 3","player") then
			CastSpellByName("Windfury Totem")
		else
			if FindBuff("Strength of Earth","player") and (not FindBuff("Tranquil Air","player")) then
				CastSpellByName("Tranquil Air Totem")
			end
		end
	end
	if whichDispell=="disease" and (whichRoleDispell=="healer" or whichRoleDispell=="caster") then
		currentTarget = UnitName("target")
		ClearTarget()
		TargetByName("Disease Cleansing Totem",true)
		if not CheckInteractDistance("target",4) then
			CastSpellByName("Disease Cleansing Totem")
		end
		if not currentTarget then
			ClearTarget()
		else
			TargetByName(currentTarget)
		end
		if not FindBuff("Tranquil Air","player") then
			CastSpellByName("Tranquil Air Totem")
		end
	end
	
	--OTHER totem
	if not FindBuff("Strength of Earth","player") and (whichRoleDispell=="tank" or whichRoleDispell=="melee" or whichRoleDispell=="dps") then
		CastSpellByName("Strength of Earth Totem")
	end
end

function randomTotems(totem1,totem2,totem3,totem4)
	--totem1 = air totem
	--totem2 = water totem
	--totem3 = earth totem
	--totem4 = fire totem
	if totem1~="" and not FindBuff(totem1,"player") then
		--currentTarget = UnitName("target")
		--ClearTarget()
		--TargetByName("Windfury Totem",true)
		--if not CheckInteractDistance("target",4) then
		--	CastSpellByName("Windfury Totem")
		--end
		if totem1=="windfury" and not FindBuff("Windfury Totem 3","player") then
			CastSpellByName(totem1.." Totem")
		else
			CastSpellByName(totem1.." Totem")
		end
	end
	if totem2~="" and not FindBuff(totem2,"player") then
		CastSpellByName(totem2.." Totem")
	end
	if totem3~="" and not FindBuff(totem3,"player") then
		CastSpellByName(totem3.." Totem")
	end
	if totem4~="" and not FindBuff(totem4,"player")then
		CastSpellByName(totem4.." Totem")
	end
end

function lightningTotem(spellName)
	local currentTarget
	currentTarget = UnitName("target")
	TargetByName("Lightning Totem",true)
	if currentTarget==TargetByName("Lightning Totem") then
		CastSpellByName(spellName)
		TargetByName(currentTarget)
	end
end

function potionCds(pot1,pot2,pot3,pot4,pot5)
	local bag1,slot1,bag2,slot2,bag3,slot3,bag4,slot4,bag5,slot5
	if (pot1=="") then else bag1, slot1 = FindItem(pot1) end
	if (pot2=="") then else bag2, slot2 = FindItem(pot2) end
	if (pot3=="") then else bag3, slot3 = FindItem(pot3) end
	if (pot4=="") then else bag4, slot4 = FindItem(pot4) end
	if (pot5=="") then else bag5, slot5 = FindItem(pot5) end
	local _,duration1= GetContainerItemCooldown(bag1, slot1)
	if (duration1>0) then use(pot2) else use(pot1) end
	local _,duration2= GetContainerItemCooldown(bag2, slot2)
	if (duration2>0) then use(pot3) end
	local _,duration3= GetContainerItemCooldown(bag3, slot3)
	if (duration3>0) then use(pot4) end
	local _,duration4= GetContainerItemCooldown(bag4, slot4)
	if (duration4>0) then use(pot5) end
end

function aq40KillOrder()
	local far,sfr,m,ka,t,tc,ms,mb,ss="Fire and Arcane Reflect","Shadow and Frost Reflect","Mending","Knock Away","Thorns","Thunderclap","Mortal Strike","Mana Burn","Shadow Storm"
	local tar="target"
	superAntiSpamaq40KillOrderVariable = 0
	if not FindBuff("Detect Magic",tar) then
		cast("Detect Magic") 
	end
	if GetRaidTargetIndex(tar) > 0 and not FindBuff("Detect Magic",tar)  then
		SetRaidTarget(tar,0)
	end
	if FindBuff(far,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,8)
		SendChatMessage("Skull -> "..m,"YELL")
	end
	if FindBuff(sfr,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,7)
		SendChatMessage("Cross -> "..sfr,"YELL")
	end
	if FindBuff(m,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,2)
		SendChatMessage("Nipple -> "..far,"YELL")
	end
	if FindBuff(ka,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,1)
		SendChatMessage("Star -> "..ka,"YELL")
	end
	if FindBuff(ms,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,4)
		SendChatMessage("Triangle -> "..ms,"YELL")
	end
	if FindBuff(t,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,3)
		SendChatMessage("Purple -> "..t,"YELL")
	end
	if FindBuff(mb,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,5)
		SendChatMessage("Moon -> "..mb,"YELL")
	end
	if FindBuff(ss,tar) and not GetRaidTargetIndex(tar) then
		SetRaidTarget(tar,6)
		SendChatMessage("Blue Box -> "..ss,"YELL")
	end
	if FindBuff(tc,tar) and superAntiSpamaq40KillOrderVariable == 0 then
		SendChatMessage("Unmarked -> "..tc,"YELL")
		superAntiSpamaq40KillOrderVariable = 1
	end 
end

function promoteRaidMember(member1,member2,member3,member4,member5,member6,member7,member8,member9,member10,member11,member12,member13,member14,member15,member16,member17,member18,member19,member20,member21,member22,member23,member24,member25,member26,member27,member28,member29,member30,member31,member32,member33,member34,member35,member36,member37,member38,member39,member40)
	for i=1,GetNumRaidMembers() do
		local name=GetRaidRosterInfo(i)
		if name=="member"..i then
			PromoteToAssistant("member"..i)
		end
	end
end


--function drinkConsums(consum1, consum2, consum3, consum4, consum5, consum6, consum7, consum8, consum9, consum10)
	--local pot1="mongoose"
--	local pot2="agility"
--	local pot3="troll"
--	local pot4="fortitude"
--	local pot5="armor"
--	local pot6="giant"
--	local pot7="might"
	
	
--	if (string.find(consum1, pot1) || string.find(consum2, pot1) || string.find(consum3, pot1) || string.find(consum4, pot1) || string.find(consum5, pot1) || string.find(consum6, pot1) || string.find(consum7, pot1) || string.find(consum8, pot1) || string.find(consum9, pot1) || string.find(consum10, pot1) || ) then
--		if not FindBuff("Elixir of the Mongoose", "player") then
--			use("Elixir of the Mongoose")
--		end
--	end
	
--	if (string.find(consum1, pot2) || string.find(consum2, pot2) || string.find(consum3, pot2) || string.find(consum4, pot2) || string.find(consum5, pot2) || string.find(consum6, pot2) || string.find(consum7, pot2) || string.find(consum8, pot2) || string.find(consum9, pot2) || string.find(consum10, pot2) || ) then
--		if not FindBuff("Elixir of the Mongoose", "player") and not FindBuff("Elixir of Greater Agility", "player") then
--			use("Elixir of Greater Agility")
--		end
--	end
	
		
	
	
--end

function frostboltSwap()
	local m, f, c, i, u, r = "mouseover", "Frostbolt", CastSpellByName, IsControlKeyDown(), UnitExists, "(Rank 1)"
	SpellStopCasting()
	if u(m) then
		TargetUnit(m)
		if i then
			c(f..r)
		else
			c(f)
		end
		TargetLastEnemy()
	elseif u("target") then
		if i then
			c(f..r)
		else
			c(f)
		end
	end
end

function aoeTaunt()
	local bag,slot=FindItem("Limited Invulnerability Potion")
	if bag ~= nil and slot ~= nil then
		if OnCooldown("Challenging Shout")==0 or GetContainerItemCooldown(bag, slot)==0 then
			if UnitMana("player") >= 3 then
				if not FindBuff("Invulnerability","player") then
					UseItemByName("Limited Invulnerability Potion")
				--else
					CastSpellByName("Challenging Shout")
					SendChatMessage("AOE Taunt + LIP -> check HP please!","SAY")
				end
			end
		end
	end
end

function NoMod()
	if (not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown()) then
		return true
	else
		return false
	end
end

function nearestPlayer()
	if UnitHealth("target")==0 and UnitExists("target") then ClearTarget(); end
	if GetUnitName("target")==nil then TargetNearestEnemy() end
	if UnitExists("target") and not UnitIsPlayer("target") then TargetNearestEnemy() end
end

function chainChain(helpspell,helprank,harmspell,harmrank)
  if UnitExists("target") then
    local s=not UnitIsUnit("target", "mouseover")
  end

  if helprank == "" and harmrank == "" then
    if IsAltKeyDown() then
      TargetUnit("player")
      CastSpellByName(helpspell)
      if s then
        TargetLastTarget()
      end
    else
      if UnitIsFriend("target","player") then
        CastSpellByName(helpspell)
      else
        CastSpellByName(harmspell)
      end
    end
  end
  
  if helprank == "" and harmrank ~= "" then
    if IsAltKeyDown() then
      TargetUnit("player")
      CastSpellByName(helpspell)
      if s then
        TargetLastTarget()
      end
    else
      if UnitIsFriend("target","player") then
        CastSpellByName(helpspell)
      else
        CastSpellByName(harmspell.."(Rank "..harmrank..")")
      end
    end
  end

  if helprank ~= "" and harmrank == "" then
    if IsAltKeyDown() then
      TargetUnit("player")
      CastSpellByName(helpspell.."(Rank "..helprank..")")
      if s then
        TargetLastTarget()
      end
    else
      if UnitIsFriend("target","player") then
        CastSpellByName(helpspell.."(Rank "..helprank..")")
      else
        CastSpellByName(harmspell)
      end
    end
  end
  
  if helprank ~= "" and harmrank ~= "" then
    if IsAltKeyDown() then
      TargetUnit("player")
      CastSpellByName(helpspell.."(Rank "..helprank..")")
      if s then
        TargetLastTarget()
      end
    else
      if UnitIsFriend("target","player") then
        CastSpellByName(helpspell.."(Rank "..helprank..")")
      else
        CastSpellByName(harmspell.."(Rank "..harmrank..")")
      end
    end
  end
  
end

function weaponSwap(mh1,oh1,mh2,oh2)
	local b,s
	local currentMH = GetInventoryItemLink("player",16)
	local currentOH = GetInventoryItemLink("player",17)
	if currentOH == nil then
		currentOH = ""
	end
	if oh1 == "" or oh1 == nil or oh2 == "" or oh2 == nil then	
		if GetInventoryItemLink("player",17) == nil then
			b,s=FindItem(mh2) PickupContainerItem(b,s) EquipCursorItem(16)
			b,s=FindItem(oh2) PickupContainerItem(b,s) EquipCursorItem(17)
		else
			b,s=FindItem(mh1) PickupContainerItem(b,s) EquipCursorItem(16)
		end
	else
		--DEFAULT_CHAT_FRAME:AddMessage("I am here")
		if mh1 == oh2 and mh2 == oh1 and currentOH ~= "" then
			PickupInventoryItem(17)
			EquipCursorItem(16)
		else
			if strfind(currentMH,mh1) then
				--DEFAULT_CHAT_FRAME:AddMessage("I am here")
				b,s=FindItem(mh2) PickupContainerItem(b,s) EquipCursorItem(16)
				b,s=FindItem(oh2) PickupContainerItem(b,s) EquipCursorItem(17)
			else
				if strfind(currentMH,mh2) then
					--DEFAULT_CHAT_FRAME:AddMessage("I am")
					b,s=FindItem(mh1) PickupContainerItem(b,s) EquipCursorItem(16)
					b,s=FindItem(oh1) PickupContainerItem(b,s) EquipCursorItem(17)
				else
					--DEFAULT_CHAT_FRAME:AddMessage("I")
					b,s=FindItem(mh1) PickupContainerItem(b,s) EquipCursorItem(16)
					b,s=FindItem(oh1) PickupContainerItem(b,s) EquipCursorItem(17)
				end
			end
		end
	end
end

function doubleWF(mh)
	local hasMH, mainHandExpiration, mainHandCharges, hasOH, offHandExpiration, offHandCharges, hasThrownEnchant, thrownExpiration, thrownCharges = GetWeaponEnchantInfo()
	if mainHandExpiration == nil then
		mainHandExpiration = ""
	end

	if not hasMH and not hasOH and not strfind(GetInventoryItemLink("player",16), mh) then
		PickupInventoryItem(16)
		EquipCursorItem(17)
	end
	if GetInventoryItemLink("player",16) == GetInventoryItemLink("player",17) then
		if hasMH and hasOH ~= 1 and mainHandExpiration < 6500 then
			PickupInventoryItem(16)
			EquipCursorItem(17)
		end
	else
		--SM_print("DEBUG: hasMH="..hasMH)
		--SM_print("DEBUG: hasOH="..hasOH)
		if hasMH and hasOH ~= 1 and mainHandExpiration < 6500 then
			PickupInventoryItem(16)
			EquipCursorItem(17)
		end
		if hasMH and hasOH and not strfind(GetInventoryItemLink("player",16), mh) then
			PickupInventoryItem(16)
			EquipCursorItem(17)
		end
	end
end

function lipping()
	if UnitIsUnit("player","target") then
		use("Limited Invulnerability Potion")
	end
end

function NSprio()
	local class = UnitClass("player")
	if UnitHealth("target")/UnitMaxHealth("target")*100 < 15 then
		if class == "Shaman" then
			if OnCooldown("Nature's Swiftness")==0 then
				SpellStopCasting()
				CastSpellByName("Nature's Swiftness")
				CastSpellByName("Healing Wave")
			end
		end
		if class == "Druid" then
			if OnCooldown("Nature's Swiftness")==0 then
				SpellStopCasting()
				CastSpellByName("Nature's Swiftness")
				CastSpellByName("Healing Touch")
			end
		end
	end
end

function gibWF(player)
	local myName, mySubgroup, myClass
	for i = 1, MAX_RAID_MEMBERS do
		local raidName, _, raidSubgroup, _, raidClass = GetRaidRosterInfo(i)
		local shamanName, _, shamanSubgroup, _, shamanClass = GetRaidRosterInfo(i)
		if raidName == player then
			myName = raidName
			mySubgroup = raidSubgroup
			myClass = raidClass
		end
		if shamanSubgroup == mySubgroup and UnitAffectingCombat("player") and cryNoWF then
			SendChatMessage("<- pls place WF totem closer", "WHISPER", nil, shamanName)
			cryNoWF = False
		else
			cryNoWF = True
		end
	end
end
















