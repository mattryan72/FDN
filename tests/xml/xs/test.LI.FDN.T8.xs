#DESCRIPTION "FDN v9 Phase 0 C1 - T8 does X3 regex support ^ and \. (B9 fix check)"
#VERSION 1
function main()
{
   $obj = PLAYERSHIP;
   if not $obj->exists()
   {
      writeLogFile(9999, TRUE, "T8 abort: no player ship, run from a ship");
      return null;
   }
   $obj->setData("FDN.Test.A", 1);
   $obj->setData("XFDNY", 2);
   // backslash escaping in MSCI strings is unverified, so test one and two backslashes, plus a bracket form that needs none
   $arr = $obj->getLocalVarsMatchingRegex("^FDN\.");
   writeLogFile(9999, TRUE, "T8 regex ^FDN(one backslash). -> " + arraySize($arr));
   $arr = $obj->getLocalVarsMatchingRegex("^FDN\\.");
   writeLogFile(9999, TRUE, "T8 regex ^FDN(two backslashes). -> " + arraySize($arr));
   $arr = $obj->getLocalVarsMatchingRegex("^FDN[.]");
   writeLogFile(9999, TRUE, "T8 regex ^FDN[.] -> " + arraySize($arr));
   $arr = $obj->getLocalVarsMatchingRegex("FDN[.]");
   writeLogFile(9999, TRUE, "T8 regex FDN[.] -> " + arraySize($arr));
   $arr = $obj->getLocalVarsMatchingRegex("FDN*");
   writeLogFile(9999, TRUE, "T8 regex FDN* -> " + arraySize($arr));
   $obj->setData("FDN.Test.A", null);
   $obj->setData("XFDNY", null);
   $arr = $obj->getLocalVarsMatchingRegex("FDN*");
   writeLogFile(9999, TRUE, "T8 after clear FDN* -> " + arraySize($arr));
   return null;
}
