#DESCRIPTION "FDN v9 Phase 0 C3 - T9b FL only: Station Manager detection with the task constant and the time local (read only)"
#VERSION 1
function main(STATION $station)
{
   if not $station->exists()
   {
      writeLogFile(9999, TRUE, "T9b abort: pick a station as the argument");
      return null;
   }
   writeLogFile(9999, TRUE, "T9b ---- station: " + $station);
   if ($station->isScriptOnStack("plugin.stationmgr.run", Tasks::StationManage))
   {
      writeLogFile(9999, TRUE, "T9b stationmgr.run on stack of Task.StationMgr = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T9b stationmgr.run on stack of Task.StationMgr = FALSE");
   }
   if ($station->isTaskRunning(Tasks::StationManage))
   {
      writeLogFile(9999, TRUE, "T9b task Task.StationMgr running = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T9b task Task.StationMgr running = FALSE");
   }
   $now = getPlayingTime();
   $last = $station->getData("egosoft.stationmgr.time");
   writeLogFile(9999, TRUE, "T9b playing time = " + $now + ", egosoft.stationmgr.time = " + $last);
   return null;
}
