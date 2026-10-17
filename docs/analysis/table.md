| Script | Lines (code) | Args | Purpose | Calls (START*) | al.Settings idx | Locals | Text IDs |
|---|---|---|---|---|---|---|---|
| al.LI.FDN.event | 54 (40) | al.PluginID, al.Event | AL event handler; creates settings array; timer 25 s -> Supply.Start | Setup, Supply.Start | 0,1,2,3,4,5,6,7 | - | 100 |
| al.plugin.LI.FDN.register | 9 (4) | - | AL bootstrap: load text 9910, register AL event script | - | - | - | - |
| lib.BW.isAP | 16 (7) | - | Returns TRUE if script engine >= 50 (AP/FL) | - | - | - | - |
| plugin.LI.FDN.Buy.Ware | 135 (75) | factory, ware, amount | Buys ware for a factory via temporary player freighter | Sector.Array | 1,2,7,8 | ware/fac | 4000 |
| plugin.LI.FDN.Cleanup | 33 (11) | - | Nulls FDND.* globals used by dynamic menus | - | - | - | - |
| plugin.LI.FDN.Config.Menu | 240 (156) | menu | Config view: DC select/change, auto-manage, dynamic, debug, reset | Format.Name | 1,2,6,7,9 | - | 103, 104, 105, 106, 107, 108, 109, 119 (+9) |
| plugin.LI.FDN.Format.Name | 29 (8) | object | Formats "name [ID]" (text 134) | - | 1 | - | 134 |
| plugin.LI.FDN.Main.Menu | 585 (459) | - | Menu controller (views 1,2,4,5,6,7) + command dispatcher | lib.BW.isAP, Cleanup*, Config.Menu, Menu.AP.DC.Details, Menu.AP.Dock.Details, Menu.AP.Factory.List, Menu.DC.Details, Menu.DC.Details_D*, Menu.Dock.Details, Menu.Dock.Details_D*, Menu.Factory.Details, Menu.Factory.List, Menu.Ware.Details, Move.Ware, Reset, Update.Ware | 1,2,3,5,6,7,9 | ware/fac | 102, 103, 110, 111, 112, 114, 133, 182 (+7) |
| plugin.LI.FDN.Menu.AP.DC.Details | 165 (88) | menu | AP DC view (native groupings) | Format.Name, Sort.Wares | 1,2 | - | 115, 129, 140, 142, 143, 144, 145, 164 (+8) |
| plugin.LI.FDN.Menu.AP.Dock.Details | 145 (77) | menu, value | AP dock view | Format.Name, Sort.Wares | 1 | - | 140, 143, 145, 147, 195, 196, 198, 199 (+3) |
| plugin.LI.FDN.Menu.AP.Factory.List | 250 (165) | menu | AP stations view: sectors > factories + docks; global toggles | Format.Name, Sector.Array | 1,2,9 | ware/fac | 157, 158, 159, 160, 161, 162, 163, 166 (+11) |
| plugin.LI.FDN.Menu.DC.Details | 196 (108) | menu | TC DC view (manual +/- groups) | Format.Name, Sort.Wares | 1,2 | ware/fac | 18, 19, 115, 118, 129, 140, 142, 143 (+9) |
| plugin.LI.FDN.Menu.DC.Details_D | 164 (74) | - | Background updater for DC view rows (FDND.* globals) | Wares.Summary | 0,1,2,5,6 | - | 146, 202, 5000, 5001 |
| plugin.LI.FDN.Menu.Dock.Details | 175 (94) | menu, value | TC dock view | Format.Name, Sort.Wares | 1 | ware/fac | 18, 19, 115, 140, 143, 145, 147, 195 (+4) |
| plugin.LI.FDN.Menu.Dock.Details_D | 152 (69) | value | Background updater for dock view rows | Wares.Summary | 0,1,5,6 | - | 146, 202, 5000, 5001 |
| plugin.LI.FDN.Menu.Factory.Details | 121 (96) | menu, value | Factory view: product/resource toggles | Format.Name | 1 | ware/fac | 137, 138, 139, 148, 149, 4001 |
| plugin.LI.FDN.Menu.Factory.List | 243 (167) | menu, factory.show.array | TC stations view | Format.Name, Sector.Array | 1,2,9 | ware/fac | 157, 158, 159, 160, 161, 162, 163, 166 (+10) |
| plugin.LI.FDN.Menu.Ware.Details | 313 (247) | menu, value, ware | Ware view: caps, prices, buy/sell, move, regroom, remove | Format.Name | 1,2 | ware/fac | 148, 149, 170, 171, 172, 173, 174, 175 (+10) |
| plugin.LI.FDN.Move.Ware | 154 (90) | ware, source | User transfer of ware from dock/DC to any player ship/station | Update.Ware | 1,7 | ware/fac | 178, 184, 192, 193, 194, 4000 |
| plugin.LI.FDN.Reset | 75 (37) | - | Master reset: clears FDN* locals on DC/factories/docks, empties arrays | - | 2,3,4 | ware/fac | - |
| plugin.LI.FDN.Sector.Array | 134 (75) | search | Scans all player stations; fills factory/dock arrays; returns sectors list | - | 2,3,4,8 | - | - |
| plugin.LI.FDN.Sell.Ware | 138 (81) | dock, ware, amount | Sells dock surplus via temporary player freighter | Sector.Array, Update.Ware | 1,7,8 | ware/fac | 4000 |
| plugin.LI.FDN.Setup | 60 (30) | - | Add/remove FDN entry in Community Plugin Config menu; resets debug log | plugin.config.addscript | 0,1 | - | 101, 102 |
| plugin.LI.FDN.Sort.Wares | 129 (82) | station | Groups tradeable wares by maintype for menus | - | - | - | - |
| plugin.LI.FDN.Supply.Dock.Check | 77 (33) | - | Loops dock array, purges dead, starts Supply.Dock (DC flag=1) | Supply.Dock* | 1,2,4,7 | - | - |
| plugin.LI.FDN.Supply.Dock | 172 (99) | dock, flag | Dock maintain levels from DC, surplus back to DC, triggers selling | Sell.Ware*, Update.Ware | 1,2 | ware/fac | 4000 |
| plugin.LI.FDN.Supply.Factory.Check | 169 (94) | - | Loops factory array, purges dead, starts Supply.Factory (product / resources) | Supply.Factory* | 1,3,7,9,12 | ware/fac | 4001 |
| plugin.LI.FDN.Supply.Factory | 151 (79) | factory, flag | Moves product to DC; supplies primary resources from DC, else buys | Buy.Ware*, Update.Ware | 1,2,7 | ware/fac | 4000 |
| plugin.LI.FDN.Supply.Start | 104 (54) | - | Per-tick scheduler: rescan stations, start factory check, dock check every 7th tick | Sector.Array*, Supply.Dock.Check*, Supply.Factory.Check* | 1,2,3,4,7,11,12 | - | - |
| plugin.LI.FDN.Update.Ware | 161 (92) | ware, amount, station, action | Core stock API: add/remove/create, physical first then virtual | - | 1 | ware/fac | 4000 |
| plugin.LI.FDN.Wares.Summary | 272 (186) | station, ware | Builds one formatted ware row for DC or dock menus; lazily creates ware record | - | 1,2 | ware/fac | 150, 151, 152, 153, 154, 155, 4000, 9000 (+1) |

