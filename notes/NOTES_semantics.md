# NOTES_semantics: Phase 0 in-game test results

Game: X3 Farnham's Legacy 1.3 with the Unofficial Patch 1.3.20 (Matt's PC, Steam, `D:\Steam\steamapps\common\X3 Terran Conflict\addon2`).
Scripts: compiled test XMLs from `tests/xml/` (sources in `tests/xml/xs/`), saved at engine 50. Run by Matt on 2026-10-17. Output from `log09999.txt`.

Status: T1, T2, T3, T4, T7 and T8 are done. T5, T6 and T9 are **pending**: the ware/station argument arrived as null, so those scripts stopped early. See "Pending" below.

## Raw log

```
T1 null >= 0 -> FALSE
T1 null < 6 -> FALSE
T1 null == 0 -> FALSE
T2 before: 1/2/3
T2 returned: 3/2/1
T2 after: 1/2/3
T3 before [0]: 1
T3 after [0]: 42
T4 create ship returned Your Mercury Super Freighter XL
T4 before destruct: $obj -> exists = TRUE
T4 after destruct: if $obj = TRUE
T4 after destruct: $obj -> exists = FALSE
T5 station found: null
T5 abort: no station sells null
T6 abort: no station sells null
T7 script engine version = 60
T8 regex ^FDN(one backslash). -> 1
T8 regex ^FDN(two backslashes). -> 0
T8 regex ^FDN[.] -> 1
T8 regex FDN[.] -> 1
T8 regex FDN* -> 2
T8 after clear FDN* -> 0
T9 abort: pick a station as the argument
```

## Results

### T1: comparisons with null (B4)
- `null >= 0`, `null < 6` and `null == 0` are all **FALSE**. MSCI does not treat null as 0 in comparisons. Any comparison with null fails.
- **Rule:** a positive guard (`if $x >= 0`) skips null safely. A negative guard does not: `if not $x >= 0`, `if $x < 0 ... skip`, or the `else` branch of a comparison will **take** null. Always check `is datatyp[ $x ] == DATATYPE_INT` (or `if $x` for objects) before such guards.
- Arithmetic with null (`$stock - null`) was not tested. Assume it may act as 0 (VERIFY if a fix depends on it).

### T2: `reverse array` (B13)
- It returns a **new, reversed array**. The original array is unchanged (still `1/2/3`).
- **B13 confirmed.** Supply.Factory.Check L038 `$factory.array = reverse array $factory.array` swaps the local to a copy. On reversed passes `remove element from array $factory.array` (L141) edits the copy, so `[3]` keeps dead factories. The P1-02 fix (walk by index, no reverse) stands.

### T3: arrays from `get global variable`
- The returned array is a **reference** to the stored array. `$b[0] = 42` changed what the next `get global variable` returned, without `set global variable`.
- **Rule:** `$a = $al.Settings[3]` (and any array read from a global or local variable) is shared. Editing it edits the stored settings at once. Copy explicitly (new array + copy loop) when a script must not change the stored data. `set global variable` is still the safe way to replace a whole value, but it is not needed after element edits.
- With T2: only `reverse array` (and other commands that build new arrays) create copies. Plain assignment never copies.

### T4: variable holding a destroyed object (B3)
- After `destruct`, `if $obj` is still **TRUE** (the variable is not cleared), but `$obj -> exists` is **FALSE**.
- **B3 confirmed in-game:** checks like Supply.Start L046 `if $dc` do not catch a destroyed DC. Always use `-> exists`, which the MSCI_PRIMER rule already says.
- `create ship` with `SS_SH_A_TS_5` (FDN's drone type) works on FL. It is named "Mercury Super Freighter XL".

### T7: script engine version (lib.LI.FDN.Game)
- FL 1.3 + Unofficial Patch 1.3.20 returns **60**.
- Scripts saved at engine 50 (FDN v8.04, these tests) load and run on FL.
- `lib.BW.isAP` (`>= 50`) is TRUE on FL, as expected.
- **Still needed:** the AP 3.3 value (run T7 on AP), and ideally FL **without** the patch. The patch notes say it "increased" the engine version, so vanilla FL may return less than 60.
- Provisional thresholds for `lib.LI.FDN.Game` (VERIFY with the AP number): `>= 60` gives FL (3); `>= 50` gives AP (2); otherwise TC (1). If vanilla FL turns out to report the same as AP, the version alone cannot tell AP from FL. Then add an FL-only check as well, for example whether a script command that only FL has gives a result.

### T8: regex in `get local variables: regular expression` (B9)
- **Anchors and escapes work.** `^FDN\.` typed with **one** backslash matched only `FDN.Test.A` (1). Two backslashes (`^FDN\\.`) matched nothing (0). MSCI strings are stored literally, with no escape processing.
- `^FDN[.]` (1) and `FDN[.]` (1) also work, without a backslash.
- v8's `FDN*` matched **2**: it also hit `XFDNY`. That confirms the B9 leak in-game.
- Setting a local variable to null **removes** it. After clearing, `FDN*` matched 0, so the Reset clear method works.
- **Use for B9:** `'^FDN\.'` with a single backslash, as the plan says. `'^FDN[.]'` is an equally good fallback if a tool might double the backslash. Never write `\\` in MSCI string literals. For dynamic-menu globals, `'^FDND\.'` is the anchored equivalent of Cleanup's `'FDND.*'`.

## Pending

- **T5, T6, T9:** the ware (T5/T6) or station (T9) argument arrived as null. The compiled argument block matches real editor-saved scripts with Var/Ware and Var/Station arguments (codearray `[[13,'ware']]` / `[[12,'station']]`, the same as PM v7.2 and FDN v8). The XML `<arguments>` index was changed to 0-based to match those scripts exactly. Rerun: when the editor asks for the argument, pick a ware or station from the selection. Pressing Enter or Esc on the prompt passes null.
- **T7 on AP 3.3** (and FL without the patch, if easy).
- **T9 detection** for `lib.LI.FDN.Is.FL.Managed`.
