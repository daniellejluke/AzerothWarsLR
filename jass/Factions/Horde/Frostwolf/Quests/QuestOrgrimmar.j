//If Thrall enters the Orgrimmar area, OR a time elapses, OR Frostwolf leaves, give Orgrimmar to a Horde player.

library QuestOrgrimmar initializer OnInit requires QuestData, Persons, WarsongConfig, FrostwolfConfig, NewHordeConfig, MannorothConfig

  globals
    private constant real ORGRIMMAR_TIMER = 600.     //How long it takes for Orgrimmar to be built instantly
    private constant integer GOLD = 100
    private constant integer LUMBER = 350
    private boolean Built = false

    private QuestData QUEST_ORGRIMMMAR
    private QuestItemData QUESTITEM_VISIT
  endglobals

  private function Build takes nothing returns nothing
    local group tempGroup = CreateGroup()
    local unit u
    local Person tempPerson = 0
    local player recipient = Player(PLAYER_NEUTRAL_AGGRESSIVE)

    set Built = true

    if PersonsByFaction[FACTION_FROSTWOLF] != 0 then                 
      set tempPerson = PersonsByFaction[FACTION_FROSTWOLF]
    elseif PersonsByFaction[FACTION_NEW_HORDE] != 0 then
      set tempPerson = PersonsByFaction[FACTION_NEW_HORDE]  
    elseif PersonsByFaction[FACTION_WARSONG] != 0 then
      set tempPerson = PersonsByFaction[FACTION_WARSONG]
    elseif PersonsByFaction[FACTION_MANNOROTH] != 0 then
      set tempPerson = PersonsByFaction[FACTION_MANNOROTH]
    endif
    if tempPerson != 0 then
      set recipient = tempPerson.p  
    endif

    //Transfer all Neutral Passive units in Orgrimmar to one of the above factions
    call GroupEnumUnitsInRect(tempGroup, gg_rct_Orgrimmar, null)
    set u = FirstOfGroup(tempGroup)
    loop
    exitwhen u == null
      if GetOwningPlayer(u) == Player(PLAYER_NEUTRAL_PASSIVE) then
        call SetUnitInvulnerable(u, false)
        call SetUnitOwner(u, recipient, true)
      endif
      call GroupRemoveUnit(tempGroup, u)
      set u = FirstOfGroup(tempGroup)
    endloop
    //Give resources and display message
    call AdjustPlayerStateBJ(GOLD, recipient, PLAYER_STATE_RESOURCE_GOLD )
    call AdjustPlayerStateBJ(LUMBER, recipient, PLAYER_STATE_RESOURCE_LUMBER )  
    //Complete quests
    call FACTION_FROSTWOLF.setQuestItemStatus(QUESTITEM_VISIT, QUEST_PROGRESS_COMPLETE, true)
    //Cleanup
    call DestroyGroup (tempGroup)
    set recipient = null
    set tempGroup = null
  endfunction

  private function TimerEnds takes nothing returns nothing
    call Build()
  endfunction

  private function EntersRegion takes nothing returns nothing
    if GetUnitTypeId(GetTriggerUnit()) == 'Othr' then   //This is Thrall
      call Build()
    endif
  endfunction    

  private function PersonFactionChanges takes nothing returns nothing
    if GetChangingPersonPrevFaction() == FACTION_FROSTWOLF then
      call Build()
    endif
  endfunction

  private function Conditions takes nothing returns boolean
    return not Built
  endfunction

  private function OnInit takes nothing returns nothing
    local trigger trig = null

    set trig = CreateTrigger()
    call TriggerRegisterEnterRectSimple(trig, gg_rct_Orgrimmar)
    call TriggerAddCondition(trig, Condition(function Conditions))
    call TriggerAddAction(trig, function EntersRegion)

    set trig = CreateTrigger()
    call TriggerRegisterTimerEvent(trig, ORGRIMMAR_TIMER, false)
    call TriggerAddCondition(trig, Condition(function Conditions))
    call TriggerAddAction(trig, function TimerEnds)  

    set trig = CreateTrigger()
    call OnPersonFactionChange.register(trig)
    call TriggerAddCondition(trig, Condition(function Conditions))
    call TriggerAddAction(trig, function PersonFactionChanges)    

    //Quest setup
    set QUEST_ORGRIMMMAR = QuestData.create("To Tame a Land", "Since arriving on Azeroth, the Orcs have never had a place to call home. The uncharted lands of Kalimdor are ripe for colonization.", "At the northern edge of Durotar, the Horde has finally found a place to call home. They name it Orgrimmar in honour of Orgrim Doomhammer.", "ReplaceableTextures\\CommandButtons\\BTNFortress.blp")
    set QUESTITEM_VISIT = QUEST_ORGRIMMMAR.addItem("Survive until turn 10 OR bring Thrall to Orgrimmar")
    call FACTION_FROSTWOLF.addQuest(QUEST_ORGRIMMMAR)
  endfunction

endlibrary