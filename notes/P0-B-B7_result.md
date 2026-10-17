# P0-B-B7: B7 dock dynamic toggle uses the wrong index — REVIEW ONLY (no code written)

**CORRECTION (per Matt): Section 3 below is WRONG.** The `'dynamic.dock.list'` block in Main.Menu and everything else stays as it currently stands; the fix is **only `plugin.LI.FDN.Menu.Dock.Details_D.txt` line 026**, changing `$al.Settings[6][1]` to `$al.Settings[6][2]`. Do not apply any other index change from this review.

---

### Task P0-B-B7: B7 — dock dynamic toggle uses the wrong index (review only)

**Assumptions:**
- The settings table on the prompt background (idx 6 = `is.dynamic` array, `[0]` DC view, `[1]` dock list with UI removed, `[2]` dock view) is correct.
- `Menu.Dock.Details_D` is the dynamic updater for the per-dock "Dock Details" menu (view value 5, per its own comment at line 041), so it should track the *dock view* flag, i.e. index 2.

**Questions for Matt:**
- None — the three pasted files are sufficient to settle this review.

---

#### 1. Quoted code (exact lines)

**`plugin.LI.FDN.Menu.Dock.Details_D.txt`:**
```
025   $open.menu = $al.Settings[5]
026   $is.dynamic = $al.Settings[6][1]
027 end
...
040 * While loop which runs whilst the LI.FDN.Menu.Dock.Details menu is open
041 * open.mene as stored in the AL Plugin global variable
042 if $is.dynamic
043  while [TRUE]
```

**`plugin.LI.FDN.Config.Menu.txt`:**
```
167 $temp.array = = array alloc: size=4
168 $temp.array[0] = 1
169 $txt = = read text: page=$PageID id=106
170 $temp.array[1] = $txt
171 $temp.array[2] = -1
172 if $is.dynamic[2]
173  $txt = = read text: page=$PageID id=148
174 else
175  $txt = = read text: page=$PageID id=149
176 end
177 $temp.array[3] = $txt
...
179 $format = = create new array, arguments=$temp.array, 'dynamic.dock', null, null, null
```

**`plugin.LI.FDN.Main.Menu.txt`:**
```
268 else if $return == 'dynamic.dock'
269  if $is.dynamic[1]
270   $is.dynamic[1] = null
271  else
272   $is.dynamic[1] = 1
273   
274  end
```

#### 2. Verdict: **CONFIRMED** (with one correction to the bug note's own line reference)

- Config.Menu line 172 reads `$is.dynamic[2]` for the menu row whose label is text id 106 and whose return value is `'dynamic.dock'` (line 179). Per the settings table, index `[2]` = dock view — so the **displayed state** of the toggle comes from index 2.
- Menu.Dock.Details_D line 026 reads `$al.Settings[6][1]` and line 042 gates its whole update loop on it — but index `[1]` is "dock list (UI removed)", a flag with no live UI left, so the updater's gate never reflects what the user sees in config.
- Main.Menu lines 268–274: the `'dynamic.dock'` return handler toggles `$is.dynamic[1]`, i.e. it flips index **1**, not index **2**. So flipping the visible toggle writes to a flag that nothing displays, while both what is displayed (Config `[2]`) and what controls the updater (`[1]` read in Details_D) are out of sync with each other — the toggle appears dead. That matches the bug note's "the toggle does nothing."

#### 3. Line-number correction

> **CORRECTED PER MATT: this whole section is wrong — do not act on it.** The only change for B7 is Menu.Dock.Details_D line 026, `$al.Settings[6][1]` → `$al.Settings[6][2]`. No changes to Main.Menu or anywhere else.

The bug note points to "Main.Menu 261-266", but that range is actually the **`'dynamic.dock.list'`** handler (toggling index `[2]`). The `'dynamic.dock'` handler is at lines **268–274**. Note this makes it worse than "wrong index in one place": Main.Menu's handlers are swapped relative to Config.Menu — the `dock.list` return value writes `[2]` while its (commented-out) config row would have read `[1]`, and vice versa.

The bug note also says "Fix direction: use index 2 everywhere". For these two files that is correct (Config 172, Details_D 026→`[2]`, Main.Menu `'dynamic.dock'` handler 269/272→`[2]`). But the same change implies Main.Menu's `'dynamic.dock.list'` block at lines 262–265 (currently `$is.dynamic[2]`) should become `[1]` if it is to match its commented-out config row at Config.Menu line 156 — that block was not listed in the bug note, so flag it for the fix task rather than deciding it here.

#### 4. In-game test to settle it

1. With a DC and one dock set: open FDN menu → Configuration, toggle "Dock Details" (the `id=106` row) **on**, close the menu.
2. Open that dock's Dock Details menu and watch its credits/ware values for ~30 s while activity flows through it — with the bug present they will stay static because line 042 gates on `[1]`, which was never set by the toggle; after the one-line fix of line 026 to `$al.Settings[6][2]` the values should update live (the config row already displays from `[2]`).

*Not tested in game — this is source review only.*