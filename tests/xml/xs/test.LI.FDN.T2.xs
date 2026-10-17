#DESCRIPTION "FDN v9 Phase 0 C1 - T2 does reverse array work in place or return a copy (B13)"
#VERSION 1
function main()
{
   $a = createArray(1, 2, 3, null, null);
   $v0 = $a[0];
   $v1 = $a[1];
   $v2 = $a[2];
   writeLogFile(9999, TRUE, "T2 before: " + $v0 + "/" + $v1 + "/" + $v2);
   $r = arrayReverse($a);
   $v0 = $r[0];
   $v1 = $r[1];
   $v2 = $r[2];
   writeLogFile(9999, TRUE, "T2 returned: " + $v0 + "/" + $v1 + "/" + $v2);
   $v0 = $a[0];
   $v1 = $a[1];
   $v2 = $a[2];
   writeLogFile(9999, TRUE, "T2 after: " + $v0 + "/" + $v1 + "/" + $v2);
   return null;
}
