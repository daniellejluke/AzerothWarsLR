library QuestAndrassil initializer OnInit requires QuestData, ControlPoint, DruidsConfig, NightElfConfig

  globals
    private QuestData QUEST_ANDRASSIL
    private QuestItemData QUESTITEM_KILL
    private QuestItemData QUESTITEM_CAPTURE
  endglobals

  private function TryComplete takes nothing returns nothing
    local Person druidsPerson = FACTION_DRUIDS.whichPerson
    local unit andrassil
    if druidsPerson == 0 then
      set druidsPerson = FACTION_NIGHT_ELVES.whichPerson
    endif
    if not UnitAlive(gg_unit_u000_0649) and GetOwningPlayer(gg_unit_n03U_0281) == druidsPerson.p then
      set andrassil = CreateUnit(druidsPerson.p, 'n04F', GetRectCenterX(gg_rct_Andrassil), GetRectCenterY(gg_rct_Andrassil), 0)
      call UnitRescue(andrassil, druidsPerson.p)
      set andrassil = null
    endif
  endfunction

  private function Dies takes nothing returns nothing
    call FACTION_DRUIDS.setQuestItemStatus(QUESTITEM_KILL, QUEST_PROGRESS_COMPLETE, true)
    call FACTION_NIGHT_ELVES.setQuestItemStatus(QUESTITEM_KILL, QUEST_PROGRESS_COMPLETE, true)
    call TryComplete()
    call DestroyTrigger(GetTriggeringTrigger())
  endfunction

  private function Capture takes nothing returns nothing
    local Person capturePerson
    if GetUnitTypeId(GetTriggerControlPoint().u) == 'n03U' then
      set capturePerson = Persons[GetPlayerId(GetTriggerControlPoint().owner)]
      if capturePerson.faction == FACTION_DRUIDS or capturePerson.faction == FACTION_NIGHT_ELVES then
        call TryComplete()
        call FACTION_DRUIDS.setQuestItemStatus(QUESTITEM_CAPTURE, QUEST_PROGRESS_COMPLETE, true)
        call FACTION_NIGHT_ELVES.setQuestItemStatus(QUESTITEM_CAPTURE, QUEST_PROGRESS_COMPLETE, true)
      else
        call FACTION_DRUIDS.setQuestItemStatus(QUESTITEM_CAPTURE, QUEST_PROGRESS_INCOMPLETE, false)
        call FACTION_NIGHT_ELVES.setQuestItemStatus(QUESTITEM_CAPTURE, QUEST_PROGRESS_INCOMPLETE, false)
      endif
    endif
  endfunction

  private function OnInit takes nothing returns nothing
    local trigger trig
    local integer i = 0
    local unit u = null

    set trig = CreateTrigger()
    call TriggerRegisterUnitEvent( trig, gg_unit_u000_0649, EVENT_UNIT_DEATH )  //Frozen Throne
    call TriggerAddAction(trig, function Dies)

    set trig = CreateTrigger()
    call OnControlPointOwnerChange.register(trig)
    call TriggerAddAction(trig, function Capture)

    //Quest setup
    set QUEST_ANDRASSIL = QuestData.create("Crown of the Snow", "Long ago, Fandral Staghelm cut a sapling from Nordrassil and used it to grow Andrassil in Northrend. Without the blessing of the Aspects, it fell to the Old Gods' corruption. If Northrend were to be reclaimed, Andrassil's growth could begin anew.", "With Northrend finally free of the Lich King's influence, the time is ripe to regrow Andrassil in the hope that it can help reclaim this barren land.", "ReplaceableTextures\\CommandButtons\\BTNTreant.blp")
    set QUESTITEM_KILL = QUEST_ANDRASSIL.addItem("The Frozen Throne is destroyed")
    set QUESTITEM_CAPTURE = QUEST_ANDRASSIL.addItem("Capture Grizzly Hills")
    call FACTION_DRUIDS.addQuest(QUEST_ANDRASSIL)
    call FACTION_NIGHT_ELVES.addQuest(QUEST_ANDRASSIL)
  endfunction

endlibrary