# MSCI primer (paste only when the task writes code)

How FDN scripts look in `source_readable/*.txt`, plus the engine rules that matter. The task card says when to paste this.

Each line is `NNN  <indent><statement>`. NNN is the Script Editor line number. Indentation is one space per block level.

| Concept | Syntax seen in FDN |
|---|---|
| Comment | `* text` |
| Assign / expression | `$x = $a + 1` (integers only, no floats) |
| Command with return | `$arr = = array alloc: size=0` (the editor shows `= =` when the command template itself starts with `=`; it is still one assignment) |
| Object command | `$name = $object -> get name` , `= $station -> add $n units of $ware` (no return value) |
| If / loops | `if <expr>` … `else if <expr>` … `else` … `end` ; `while <expr>` … `end` ; `skip if <expr>` (skips the next line) ; `break` , `continue` |
| Conditions with commands | Only `<RetVar/IF>` commands can be used directly: `if $dock -> exists`, `if not find $s in array: $a` |
| Logic | `AND`, `OR`, `not`, `==`, `!=`, `<`, `>`, `<=`, `>=` |
| Subroutines | `gosub Label:` … `Label:` … `endsub` (subs share all variables; `return` inside a sub ends the whole script) |
| Call script (sync) | `$r = [THIS] -> call script plugin.X : arg1=$a  arg2=$b` or `$r = null -> call script …` |
| Start task (async) | `START  = null -> call script plugin.X : …`. Runs as a separate task; its return value is lost. |
| Arrays | `array alloc: size=N`, `size of array $a`, `append $v to array $a`, `remove element from array $a at index $i`, `$a[$i]`, `$a[$i][$j]`, `= sort array $a`, `reverse array $a`, `create new array, arguments=…`, `find $v in array: $a` |
| Arrays are references | `$s = get global variable …` gives the **same** array; `$s[3] = x` changes the global immediately. Assigning a plain local (`$flag = 1`) does **not** change the array (see bug B1). |
| Globals / locals | `get/set global variable: name='…' value=…`; `$obj -> get/set local variable: name=… value=…`; `get global variables: regular expression='…'`. Both are stored in save games. |
| Text | `load text: id=9910`; `read text: page=$PageID id=102`; `sprintf: pageid=$PageID textid=4000, $ware, null, null, null, null` |
| Timing | `= wait 1000 ms`, `= wait randomly from 500 to 1000 ms` |
| Types | `is datatyp[ $x ] == DATATYPE_NULL / DATATYPE_ARRAY / DATATYPE_WARE / DATATYPE_INT` |
| Logging | `write to log file $DebugID  append=[TRUE]  value=$txt` → `log09910.txt` in the game folder (Documents\Egosoft\…) |
| Constants | `[TRUE]`, `[FALSE]`, `null`, `[THIS]`, `[PLAYERSHIP]`, classes `Dock 2007`, `Factory 2006`, `Complex Hub`, `[SSTYPE_LASER]`… |

Execution model (keep these in mind):
* Scripts are **cooperative**. A task runs until it hits a `wait` or another interruptible command, so code between two waits behaves as atomic. Races between FDN tasks happen **across waits**: re-read state and re-validate objects after every wait.
* `null` behaves like 0/false in comparisons. **Always null-check arrays and records before comparing their elements** (bug B4).
* An object variable can point to a destroyed object: `if $obj` is not enough (test T4: still TRUE after destruct), so use `$obj -> exists`.
* Comparisons with null are always FALSE (`null >= 0`, `null < 6`, `null == 0`; test T1), so negative guards and `else` branches take null. Arrays are shared references (T3); `reverse array` returns a copy (T2). Regex strings use one backslash: `'^FDN\.'` (T8). For ownership use `$obj -> get owner race` == `Player`.
* Long loops must `wait` periodically; the engine has infinite-loop detection.
* Running tasks keep the script version they started with (`is new script version available` exists for long loops). Long-lived loops should exit when that returns TRUE.
