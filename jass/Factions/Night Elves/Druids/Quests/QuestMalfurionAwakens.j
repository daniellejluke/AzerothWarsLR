//Anyone on the Night Elves team approaches Moonglade with a unit with the Horn of Cenarius,
//Causing Malfurion to spawn.

library QuestMalfurionAwakens initializer OnInit requires QuestData, DruidsConfig

  globals
    private constant integer HORN_OF_CENARIUS = 'cnhn'
    private constant integer GHANIR = 'I00C'

    private QuestData QUEST_MALFURION
    private QuestItemData QUESTITEM_ARTIFACT
    private QuestItemData QUESTITEM_VISIT

    private boolean Complete = false
  endglobals

  private function EntersRegion takes nothing returns nothing
    local Person druidsPerson = PersonsByFaction[FACTION_DRUIDS]
    local player druidsPlayer = druidsPerson.p
    local Person triggerPerson = 0
    local Artifact tempArtifact = 0

    if UnitHasItemOfTypeBJ(GetTriggerUnit(), HORN_OF_CENARIUS) and IsUnitAliveBJ(gg_unit_nbwd_0737) then
      set triggerPerson = Persons[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]
      if triggerPerson.team.containsPlayer(druidsPerson.p) then
        call FACTION_DRUIDS.setQuestItemStatus(QUESTITEM_VISIT, QUEST_PROGRESS_COMPLETE, true)
        if LEGEND_MALFURION.Unit == null then
          call LEGEND_MALFURION.Spawn(druidsPerson.p, GetRectCenterX(gg_rct_Moonglade), GetRectCenterY(gg_rct_Moonglade), 270)
          call UnitAddItem(LEGEND_MALFURION.Unit, ARTIFACT_GHANIR.item)
        else
          call SetItemPosition(ARTIFACT_GHANIR.item, GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
        endif
        set Complete = true
        call DestroyTrigger(GetTriggeringTrigger())
      endif
    endif

    set druidsPlayer = null
  endfunction

  private function PickupItem takes nothing returns nothing
    if GetItemTypeId(GetTriggerArtifact().item) == HORN_OF_CENARIUS and GetTriggerArtifact().owningPerson == FACTION_DRUIDS.whichPerson then
      call FACTION_DRUIDS.setQuestItemStatus(QUESTITEM_ARTIFACT, QUEST_PROGRESS_COMPLETE, true)
    endif
  endfunction

  private function Dies takes nothing returns nothing
    if not Complete then
      call FACTION_DRUIDS.setQuestItemStatus(QUESTITEM_VISIT, QUEST_PROGRESS_FAILED, true)
    endif
  endfunction

  private function OnInit takes nothing returns nothing
    local trigger trig = CreateTrigger()
    call TriggerRegisterEnterRectSimple(trig, gg_rct_Moonglade)
    call TriggerAddCondition(trig, Condition(function EntersRegion))

    set trig = CreateTrigger()
    call OnArtifactAcquire.register(trig)
    call TriggerAddAction(trig, function PickupItem)

    set trig = CreateTrigger()
    call TriggerRegisterUnitEvent( trig, gg_unit_nbwd_0737, EVENT_UNIT_DEATH )  //Barrow Den
    call TriggerAddAction(trig, function Dies)

    set QUEST_MALFURION = QuestData.create("Awakening of Stormrage", "Ever since the War of the Ancients ten thousand years ago, Malfurion Stormrage and his druids have slumbered within the Barrow Den. Now, their help is required once again.", "Malfurion has emerged from his deep slumber in the Barrow Den.", "ReplaceableTextures\\CommandButtons\\BTNFurion.blp")
    set QUESTITEM_ARTIFACT = QUEST_MALFURION.addItem("Acquire the Horn of Cenarius")
    set QUESTITEM_VISIT = QUEST_MALFURION.addItem("Bring the Horn of Cenarius to the Barrow Den")
    call FACTION_DRUIDS.addQuest(QUEST_MALFURION)
  endfunction

endlibrary