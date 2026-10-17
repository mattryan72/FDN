#DESCRIPTION "FDN v9 Phase 0 C3 - T9 FL only: what marks a station run by Station Manager (read only)"
#VERSION 1
function main(STATION $station)
{
   if not $station->exists()
   {
      writeLogFile(9999, TRUE, "T9 abort: pick a station as the argument");
      return null;
   }
   $name = $station->getName();
   writeLogFile(9999, TRUE, "T9 ---- station: " + $name + " (" + $station + ")");
   // every local variable name on the station
   $vars = $station->getLocalVarsMatchingRegex(".*");
   $s = arraySize($vars);
   writeLogFile(9999, TRUE, "T9 local variables: " + $s);
   while ($s > 0)
   {
      dec($s);
      $var = $vars[$s];
      writeLogFile(9999, TRUE, "T9   local: " + $var);
   }
   // Station Manager runs as a station task (Tasks::StationManage = 448)
   if ($station->isTaskRunning(448))
   {
      writeLogFile(9999, TRUE, "T9 task 448 (Station Manager) running = TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T9 task 448 (Station Manager) running = FALSE");
   }
   $tasks = $station->getAllRunningTasks();
   $s = arraySize($tasks);
   writeLogFile(9999, TRUE, "T9 running tasks: " + $s);
   while ($s > 0)
   {
      dec($s);
      $task = $tasks[$s];
      writeLogFile(9999, TRUE, "T9   task: " + $task);
   }
   return null;
}
