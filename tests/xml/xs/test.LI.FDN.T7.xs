#DESCRIPTION "FDN v9 Phase 0 C1 - T7 log the raw script engine version (AP / FL detection)"
#VERSION 1
function main()
{
   $scriptEngineVersion = getEngineVersion();
   writeLogFile(9999, TRUE, "T7 script engine version = " + $scriptEngineVersion);
   return null;
}
