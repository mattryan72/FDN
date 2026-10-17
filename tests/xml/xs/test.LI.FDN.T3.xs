#DESCRIPTION "FDN v9 Phase 0 C1 - T3 array reference rule through get global variable"
#VERSION 1
function main()
{
   $a = arrayAlloc(3);
   $a[0] = 1;
   setGlobalData("FDND.T3.test", $a);
   $b = getGlobalData("FDND.T3.test");
   $v = $b[0];
   writeLogFile(9999, TRUE, "T3 before [0]: " + $v);
   $b[0] = 42;
   $c = getGlobalData("FDND.T3.test");
   $v = $c[0];
   writeLogFile(9999, TRUE, "T3 after [0]: " + $v);
   setGlobalData("FDND.T3.test", null);
   return null;
}
