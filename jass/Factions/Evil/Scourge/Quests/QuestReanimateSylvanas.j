library QuestReanimateSylvanas initializer OnInit requires QuestData, ScourgeConfig, QuelthalasConfig

  globals
    private constant integer SYLVANAS_RESEARCH = 'R02D'
    private constant integer SYLVANAS_ID = 'uswb'
    private constant integer JENALLA_ID = 'H02B'

    private QuestData QUEST_KILL_SYLVANAS
    private QuestData QUESTITEM_KILL_SYLVANAS
    private QuestData QUEST_PROTECT_SYLVANAS
    private QuestItemData QUESTITEM_PROTECT_SYLVANAS
  endglobals

  private function Dies takes nothing returns nothing
    local Person triggerPerson = Persons[GetPlayerId(GetOwningPlayer(GetKillingUnit()))]
    local Person scourgePerson = PersonsByFaction[FACTION_SCOURGE]
    local Person quelPerson = PersonsByFaction[FACTION_QUELTHALAS]
    local unit jenalla = null
    local unit sylvanas = gg_unit_Hvwd_1515
    if triggerPerson.team.containsPlayer(scourgePerson.p) then
      call SetPlayerTechResearched(scourgePerson.p, SYLVANAS_RESEARCH, 1)
      call FACTION_SCOURGE.setQuestItemStatus(QUESTITEM_KILL_SYLVANAS, QUEST_PROGRESS_COMPLETE, true)
      call FACTION_QUELTHALAS.setQuestItemStatus(QUESTITEM_PROTECT_SYLVANAS, QUEST_PROGRESS_FAILED, true)
      set jenalla = CreateUnit(quelPerson.p, JENALLA_ID, 18509, 18073, 295)
      call CreateUnit(scourgePerson.p, SYLVANAS_ID, GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), GetUnitFacing(GetTriggerUnit()))
      call SetHeroXP(jenalla, GetHeroXP(sylvanas), true)
      call RemoveUnit(gg_unit_Hvwd_1515)
    endif
    set sylvanas = null
    set jenalla = null
    call DestroyTrigger(GetTriggeringTrigger())
  endfunction

  private function OnInit takes nothing returns nothing
    local trigger trig = CreateTrigger()
    call TriggerRegisterUnitEvent( trig, gg_unit_Hvwd_1515, EVENT_UNIT_DEATH )  //Sylvanas
    call TriggerAddAction(trig, function Dies)

    set QUEST_KILL_SYLVANAS = QuestData.create("The First Banshee", "Sylvanas, the Ranger-General of Silvermoon, stands between the legions of the Scourge and the Sunwell. Slay her, and her soul will be transformed into a tormented Banshee under the Scourge's control.", "Sylvanas has been slain. Her soul is ripped from her body, and she becomes the first of the High Elven Banshees.", "ReplaceableTextures\\CommandButtons\\BTNBansheeRanger.blp")
    set QUESTITEM_KILL_SYLVANAS = QUEST_KILL_SYLVANAS.addItem("Kill Sylvanas Windrunner")
    call FACTION_SCOURGE.addQuest(QUEST_KILL_SYLVANAS)

    set QUEST_PROTECT_SYLVANAS = QuestData.create("The Ranger-General", "Sylvanas, the Ranger-General of Silvermoon, stands between the Sunwell and the legions of the Scourge. If she is slain, her soul will be transformed into a tormented Banshee under the Scourge's control.", "Sylvanas been slain. She demands a clean death. Instead, her soul is ripped from her body, and she becomes the first of the High Elven Banshees.", "ReplaceableTextures\\CommandButtons\\BTNSylvanusWindrunner.blp")
    set QUESTITEM_PROTECT_SYLVANAS = QUEST_PROTECT_SYLVANAS.addItem("Protect Sylvanas Windrunner from the Scourge and its allies")
    call FACTION_QUELTHALAS.addQuest(QUEST_PROTECT_SYLVANAS)
  endfunction

endlibrary