#DESCRIPTION "FDN v9 Phase 0 C2 - T5 does a docked TS spawn at an NPC station and pass the drone checks (B15)"
#VERSION 1
function main(WARE $ware)
{
   $sector = PLAYERSHIP->getSector();
   $station = findProductBestPrice($ware, 2000, 1000, 99, $sector, null, null);
   writeLogFile(9999, TRUE, "T5 station found: " + $station);
   if not $station->exists()
   {
      writeLogFile(9999, TRUE, "T5 abort: no station sells " + $ware);
      return null;
   }
   $drone = createShip(SS_SH_A_TS_5, PlayerRace, $station, null, null, null);
   writeLogFile(9999, TRUE, "T5 create ship returned " + $drone);
   if ($drone->exists())
   {
      $name = $drone->getName();
      $maker.race = $drone->getMakerRace();
      writeLogFile(9999, TRUE, "T5 exists=TRUE name=" + $name + " maker=" + $maker.race);
   }
   else
   {
      writeLogFile(9999, TRUE, "T5 exists=FALSE");
   }
   if ($drone->IsDockingAllowed($station))
   {
      writeLogFile(9999, TRUE, "T5 docking allowed = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T5 docking allowed = FALSE");
   }
   if ($drone->canTransportWare($ware))
   {
      writeLogFile(9999, TRUE, "T5 can transport " + $ware + " = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T5 can transport " + $ware + " = FALSE");
   }
   $max.cargo = $drone->getMaxWareCount($ware);
   writeLogFile(9999, TRUE, "T5 max cargo " + $ware + " = " + $max.cargo);
   $drone->destruct(TRUE);
   $bad = createShip(null, PlayerRace, $station, null, null, null);
   writeLogFile(9999, TRUE, "T5 bad type returned " + $bad);
   return null;
}
