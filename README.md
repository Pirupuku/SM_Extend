# SM_Extend
## Installation:

Add the SM_Extend.lua file to your SuperMacros folder -> should look something like this
WoW-folder/Interface/AddOns/SuperMacros/SM_Extend.lua

Calling a function from ingame via a macro
/run name-of-funtcion(eventually-parameters)

## Current custom functions

/run startattack()

Starts your auto attack -> you need your auto attack somewhere on your action bar.

/run startAttack()

Starts your auto attack without the need of having your auto attack somewhere on your action bar (works with og UI, pfUI and MAYBE zUI and modUI).

/run stanceDance(stance, ifspell, elsespell)

Switches your stance (works for druids and warriors). Casts the "ifspell" if you are in the "stance" otherwise casts the "elsespell".

/run heroicStrike(value)

Casts Heroic Strike if you have more rage than specified with "value".

/run hamstring(amount)

Same as above just the parameter is called "amount".

/run rebuff(spellhere, targetWho)

Re-uses the buff OR debuff when the specified unit ("targetWho") doesn't have the buff/debuff.
Eg. /run rebuff("Battle Shout","player") -> casts Battle Shout if you don't have the buff
    /run rebuff("Corruption","target") -> casts Corruption if the target is not affected by it

/run StackCast(spell,numstacks)

Casts a "spell" until the stacks are reached.
Eg. /run StackCast("Sunder Armor",5) -> casts Sunder Armor until the target got 5 stacks
    /run StackCast("Scorch",5) -> same as above but with Scorch

/run OnCooldown(spell)

Checks if a "spell" is on CD.

/run hunterAutoAttack(slotNumber)

Start Hunter Auto Attack without interrupting it by spamming the button/keybind. Reference with "slotNumber" on the slot where this macro is located.

/run nearestTarget()

Targets the nearest enemy (mob/player)

/run getMobStats()

Says in Chat the mob stats of the target - does not work on players.

/run sunderArmor()

If you combine Sunder Armor with start auto attack uses this macro because KTM doesn't recognize the right value if you use Sunder Armor in a macro
Eg. /run startAttack()
    /run sunderArmor()

/run startWanding(slotCheck)

Starts wanding without interrupting.

/run petHandling(petFood)

Declare "petFood" as the name of the food your pet needs. Also casts Call Pet, Dismiss Pet, Revive Pet and Feed Pet in one button.
Eg. /run petHandling("Roasted Quail")

/run fdTrap(trapName)

You need this macro to be able to use a trap in combat -> declare "trapName" to the trap you want to lay down.

/run pummelShieldbash()

Pummel and Shield Bash in one button. If you have a shield equipped you cast Shield Bash otherwise you cast Pummel. If you are not in the right stance to cast either, you switch stances.

/run aoeTaunt()

Casts Challenging Shout and uses a LIP - IF none is on CD.

## Get icon and tooltip
Add the following line as FIRST line to every macro

/run if nil then CastSpellByName("spell(rank x)") end

Type the spell name (and rank) you want to see as icon and the respectively tooltip

Eg.: /run if nil then CastSpellByName("Flash Heal(Rank 1)") end
