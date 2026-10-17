#DESCRIPTION "FDN v9 Phase 0 C2 - T6 does destructing a docked drone fire SIGNAL_KILLED (B15)"
#VERSION 1
function main(WARE $ware)
{
   $sector = PLAYERSHIP->getSector();
   $station = findProductBestPrice($ware, 2000, 1000, 99, $sector, null, null);
   if not $station->exists()
   {
      writeLogFile(9999, TRUE, "T6 abort: no station sells " + $ware);
      return null;
   }
   $drone = createShip(SS_SH_A_TS_5, PlayerRace, $station, null, null, null);
   if ($drone->exists())
   {
      $drone->addSecondarySignal(SIGNAL_KILLED, "plugin.LI.FDN.T6.KillHandler", 100, "FDN.T6");
      writeLogFile(9999, TRUE, "T6 drone docked at " + $station + ", handler set");
      $drone->destruct(TRUE);
   }
   else
   {
      writeLogFile(9999, TRUE, "T6 abort: create ship failed");
   }
   writeLogFile(9999, TRUE, "T6 main script finished, check KillHandler line");
   return null;
}
