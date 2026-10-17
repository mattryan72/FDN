#DESCRIPTION "FDN v9 Phase 0 C1 - T4 what a variable holding a destroyed object returns (B3)"
#VERSION 1
function main()
{
   // same drone type FDN v8 uses (Buy.Ware / Sell.Ware), spawned in the player's sector
   $sector = PLAYERSHIP->getSector();
   $obj = createShip(SS_SH_A_TS_5, PlayerRace, $sector, null, null, null);
   writeLogFile(9999, TRUE, "T4 create ship returned " + $obj);
   if ($obj->exists())
   {
      writeLogFile(9999, TRUE, "T4 before destruct: $obj -> exists = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T4 before destruct: $obj -> exists = FALSE");
   }
   $obj->destruct(TRUE);
   if ($obj)
   {
      writeLogFile(9999, TRUE, "T4 after destruct: if $obj = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T4 after destruct: if $obj = FALSE (null)");
   }
   if ($obj->exists())
   {
      writeLogFile(9999, TRUE, "T4 after destruct: $obj -> exists = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T4 after destruct: $obj -> exists = FALSE");
   }
   return null;
}
