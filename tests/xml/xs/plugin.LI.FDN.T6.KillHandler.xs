#DESCRIPTION "FDN v9 Phase 0 C2 - T6 secondary SIGNAL_KILLED handler for the test drone"
#VERSION 1
function main()
{
   writeLogFile(9999, TRUE, "T6 SIGNAL_KILLED handler fired");
   return null;
}
