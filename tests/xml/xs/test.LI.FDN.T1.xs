#DESCRIPTION "FDN v9 Phase 0 C1 - T1 null comparison semantics (B4)"
#VERSION 1
function main()
{
   $n = null;
   if ($n >= 0)
   {
      writeLogFile(9999, TRUE, "T1 null >= 0 -> TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T1 null >= 0 -> FALSE");
   }
   if ($n < 6)
   {
      writeLogFile(9999, TRUE, "T1 null < 6 -> TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T1 null < 6 -> FALSE");
   }
   if ($n == 0)
   {
      writeLogFile(9999, TRUE, "T1 null == 0 -> TRUE");
   }
   else
   {
      writeLogFile(9999, TRUE, "T1 null == 0 -> FALSE");
   }
   return null;
}
