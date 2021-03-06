

library QuelthalasConfig initializer OnInit requires Faction

  globals
    Faction FACTION_QUELTHALAS
  endglobals

  private function OnInit takes nothing returns nothing
    local Faction f
    
    set FACTION_QUELTHALAS = Faction.create("Quel'thelas", PLAYER_COLOR_CYAN, "|C0000FFFF","ReplaceableTextures\\CommandButtons\\BTNSylvanusWindrunner.blp", 2)
    set f = FACTION_QUELTHALAS

    set f.AbsenceResearch = 'R04L'
    //Structures
    call f.registerObjectLimit('htow', UNLIMITED)   //Town Hall
    call f.registerObjectLimit('hkee', UNLIMITED)   //Keep
    call f.registerObjectLimit('hcas', UNLIMITED)   //Castle
    call f.registerObjectLimit('halt', UNLIMITED)   //Altar of Kings
    call f.registerObjectLimit('hlum', UNLIMITED)   //Lumber Mill
    call f.registerObjectLimit('hbla', UNLIMITED)   //Blacksmith
    call f.registerObjectLimit('hars', UNLIMITED)   //Arcane Sanctum
    call f.registerObjectLimit('hwtw', UNLIMITED)   //Scout Tower
    call f.registerObjectLimit('hatw', UNLIMITED)   //Arcane Tower
    call f.registerObjectLimit('h008', UNLIMITED)   //Arcane Tower (Improved)
    call f.registerObjectLimit('negt', UNLIMITED)   //High Elven Guard Tower
    call f.registerObjectLimit('n003', UNLIMITED)   //High Elven Guard Tower (Improved)
    call f.registerObjectLimit('h04V', UNLIMITED)   //Arcane Vault (Elven)
    call f.registerObjectLimit('nheb', UNLIMITED)   //High Elven Barracks
    call f.registerObjectLimit('hshy', UNLIMITED)   //Alliance Shipyard
    call f.registerObjectLimit('nefm', UNLIMITED)   //Elven Farm

    //Units
    call f.registerObjectLimit('nbee', UNLIMITED)   //Elven Worker
    call f.registerObjectLimit('hbot', UNLIMITED)   //Alliance Transport Ship
    call f.registerObjectLimit('hdes', UNLIMITED)   //Alliance Frigate
    call f.registerObjectLimit('hbsh', 12)          //Alliance Battle Ship 
    call f.registerObjectLimit('hhes', UNLIMITED)   //Elven Warrior
    call f.registerObjectLimit('hmpr', UNLIMITED)   //Priest
    call f.registerObjectLimit('hsor', UNLIMITED)   //Sorceress
    call f.registerObjectLimit('n0A2', UNLIMITED)   //Warlock
    call f.registerObjectLimit('hdhw', 6)           //Dragonhawk Rider
    call f.registerObjectLimit('nhea', UNLIMITED)   //Archer
    call f.registerObjectLimit('e008', 6)           //Elven Ballista
    call f.registerObjectLimit('n00A', 6)           //Farstrider
    call f.registerObjectLimit('n063', 12)          //Magus 
    call f.registerObjectLimit('n048', 6)           //Blood Mage 
    call f.registerObjectLimit('hspt', 12)          //Spell Breaker   
    call f.registerObjectLimit('nggr', 4)           //Granite Golem    

    call f.registerObjectLimit('h052', 1)           //Dar'kan
    call f.registerObjectLimit('n075', 1)           //Vareesa 

    //Upgrades
    call f.registerObjectLimit('R01S', UNLIMITED)   //Aimed Shot
    call f.registerObjectLimit('R00G', UNLIMITED)   //Feint
    call f.registerObjectLimit('R01R', UNLIMITED)   //Improved Bows
    call f.registerObjectLimit('R029', UNLIMITED)   //Magus Adept Training
    call f.registerObjectLimit('R00K', UNLIMITED)   //Power Infusion
    call f.registerObjectLimit('Rhcd', UNLIMITED)   //Cloud
    call f.registerObjectLimit('Rhss', UNLIMITED)   //Control Magic
    call f.registerObjectLimit('Rhlh', UNLIMITED)   //Improved Lumber Harvesting
    call f.registerObjectLimit('Rhac', UNLIMITED)   //Improved Masonry
    call f.registerObjectLimit('Rhse', UNLIMITED)   //Magic Sentry
    call f.registerObjectLimit('Rhpt', UNLIMITED)   //Priest Adept Training
    call f.registerObjectLimit('Rhst', UNLIMITED)   //Sorceress Adept Training
    call f.registerObjectLimit('R027', UNLIMITED)   //Warlock Adept Training
    

    //Masteries
    call f.registerObjectLimit('R01A', UNLIMITED)   //Arcane Empowerment
    call f.registerObjectLimit('R00T', UNLIMITED)   //Archery Mastery
    call f.registerObjectLimit('R00H', UNLIMITED)   //Blood Elf Mastery
    
    //Paths
    call f.registerObjectLimit('R046', UNLIMITED)   //Quel'thelas Full Mobilization
  endfunction
    
endlibrary

