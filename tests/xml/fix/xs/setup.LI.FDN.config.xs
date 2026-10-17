#DESCRIPTION "FDN v8.04 test fix - re-register the FDN Main Menu with Community Plugin Configuration on every game load (FL)"
#VERSION 1
function main()
{
   $al.Settings = getGlobalData("al.LI.FDN.event");
   if ($al.Settings)
   {
      $enabled = $al.Settings[0];
      if ($enabled)
      {
         loadText(9910);
         $section = readText(9910, 101);
         $txt = readText(9910, 102);
         this->call("plugin.config.addscript", $txt, null, "plugin.LI.FDN.Main.Menu", FALSE, $section, null, FALSE);
      }
   }
   return null;
}
